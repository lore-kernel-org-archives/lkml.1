Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbXGPX1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbXGPX1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbXGPX1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:27:33 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:36233 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbXGPX1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:27:32 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 17 Jul 2007 05:20:45 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
In-Reply-To: <20070716231855.GL21668@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0707170517110.2005@cselinux1.cse.iitk.ac.in>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in>
 <20070716204523.GJ21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707170306200.2005@cselinux1.cse.iitk.ac.in>
 <Pine.LNX.4.64.0707170322430.2005@cselinux1.cse.iitk.ac.in>
 <20070716231855.GL21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Al Viro wrote:
> On Tue, Jul 17, 2007 at 03:24:14AM +0530, Satyam Sharma wrote:
> > On Tue, 17 Jul 2007, Satyam Sharma wrote:
> > > [...]
> > > Anwyay, so I'm thinking of adding:
> > > 
> > > struct inode;
> > > 
> > > int is_not_owner(struct inode *)
> > 
> >   ^static inline                 ^inode
> > 
> > of course.
>  
> > > {
> > > 	return ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER));
> > > }
> 
> This is pointless.  If you do not have definition of struct inode
> already available, you'll get breakage on access to ->i_uid.

Yes, I realized that later :-) That was just a (dumb) sketch typed
into the mailer ... I'll send out the conversion patch after compiling
+ booting, of course.

Thanks,
Satyam
