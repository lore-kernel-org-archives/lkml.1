Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbZJMMOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbZJMMOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZJMMOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:14:37 -0400
Received: from thunk.org ([69.25.196.29]:46477 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZJMMOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:14:36 -0400
Date: Tue, 13 Oct 2009 08:13:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Weird ext4 bug: 256P used?
Message-ID: <20091013121355.GA8175@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com> <20091012222910.GB18195@mit.edu> <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com> <20091012231211.GC18195@mit.edu> <94a0d4530910121627j74faac64l29169e17c0b2961b@mail.gmail.com> <20091013010518.GA2606@mit.edu> <20091013021108.GB2606@mit.edu> <94a0d4530910130411y3dd21b07qdda870c268a6b916@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a0d4530910130411y3dd21b07qdda870c268a6b916@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 02:11:27PM +0300, Felipe Contreras wrote:
> My compiler fails because this function is already defined at
> 'lib/ext2fs/ext2fs.h' as non static.

Ah, you must be using a 64-bit 'pu' branch version of e2fsprogs.
Yeah, this patch was meant for the 'maint' branch.  A sightly
different branch is needed for the 'pu' branch.

	  	    	       	   - Ted
