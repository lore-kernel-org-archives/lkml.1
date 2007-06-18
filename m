Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXFRQhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXFRQhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXFRQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:37:41 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:44210
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbXFRQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:37:40 -0400
Message-ID: <4676B4B9.9030002@hawkeye.stone.uk.eu.org>
Date: Mon, 18 Jun 2007 17:37:13 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Bryan Henderson <hbryan@us.ibm.com>
CC: alan <alan@clueserver.org>, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <OFC119F96F.A721E445-ON882572FE.0055140A-882572FE.00571482@us.ibm.com>
In-Reply-To: <OFC119F96F.A721E445-ON882572FE.0055140A-882572FE.00571482@us.ibm.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Henderson wrote:
>> Part of the problem is that "whenever you modify a file"
>> is ill-defined, or rather, if you were to take the literal meaning of it
>> you'd end up with an unmanageable number of revisions.
> 
> Let me expand on that.  Do you want to save a revision every time the user 
> types in an editor?  Every time he runs a "save" command?  Every time a 
> program does a write() system call?  Every time a program closes a 
> modified file?  If you're adding to a C program, is every draft you 
> compile a revision, or just the final modification after the bugs are 
> worked out?
> 
> When I was very new to coding, I used VMS and thought the automatic 
> revisioning would be a great thing because it would save me when I 
> modified a program and later regretted it.  The system made a revision 
> every time I exited the editor.  But I soon found that the "previous 
> revision" to which I wanted to revert was always many editings back, since 
> I spent a lot of time trying to make the regrettable code work before 
> giving up.  VMS kept a fixed number of revisions per file.  But keeping 20 
> versions of other files would have been wasteful of disk space, directory 
> listing space, etc.
> 
> Later, I discovered what I think are superior alternatives:  RCS-style 
> version management on top of the filesystem, and automatic versioning 
> based on time instead of count of "modifications."  For example, make a 
> copy of every changed file every hour and keep it for a day and keep one 
> of those for a week, and keep one of those for a month, etc.  This works 
> even without snapshot technology and even without sub-file deltas.  But of 
> course, it's better with those.

>From what I can see this seems to be the consesus (and it sound very
sensible to me).

The question remains is where to implement versioning: directly in
individual filesystems or in the vfs code so all filesystems can use it?

Jack
