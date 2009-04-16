Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZDPPec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZDPPec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZDPPeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:34:21 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:43653 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZDPPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:34:20 -0400
Subject: Re: [PATCH RFC] ext3 data=guarded v3
From: Chris Mason <chris.mason@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
In-Reply-To: <1239881953.20254.17.camel@marge.simson.net>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <1239881953.20254.17.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 10:56:11 -0400
Message-Id: <1239893771.4346.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49E74FC5.0127:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 13:39 +0200, Mike Galbraith wrote:
> On Wed, 2009-04-15 at 13:22 -0400, Chris Mason wrote:
> > Hello everyone,
> 
> Greetings,
> 
> > This passed a longer stress test and generally seems to be working.  I
> > don't think anyone would recommend it as a default for 2.6.30, but it
> > may be a good idea to have a review party and decide if it is safe enough
> > to include so people can experiment with it.
> 
> I know you didn't say RFT, but I did some anyway, and found a 100%
> repeatable corruption scenario wrt git+umount.
> 

Well, that's a surprise.  I can trigger it here too, trying to figure
out how this is different from the fsx and fsstress hammering.  It looks
like git is just going good old fashioned writes, so I must be losing
one or two of them.

-chris


