Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYAWDoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYAWDoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 22:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYAWDnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 22:43:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54363 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYAWDnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 22:43:50 -0500
Date: Tue, 22 Jan 2008 19:50:05 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
In-reply-to: <alpine.DEB.0.999999.0801211635480.6668@p34.internal.lan>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801221950.06477.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
 <200801211209.23901.yinghai.lu@sun.com>
 <alpine.DEB.0.999999.0801211635480.6668@p34.internal.lan>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 01:37:09 pm Justin Piszcz wrote:
> 
> On Mon, 21 Jan 2008, Yinghai Lu wrote:
> 
> > On Monday 21 January 2008 11:14:02 am Justin Piszcz wrote:
> > please get x86.git
> >
> >  git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> >  cd linux-2.6
> >  #--------------{ x86.git instructions }---------->
> >  # Add Linus's tree as a remote
> >  git remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> >
> >  # Add Ingo's tree as a remote
> >  git remote add x86 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> >
> >  # With that setup, just run the following to get any changes you
> >  # don't have.  It will also notice any new branches Ingo/Linus
> >  # add to their repo.  Look in .git/config afterwards, the format
> >  # to add new remotes is easy to figure out.
> >  git remote update
> >  #-------------------------
> >  git merge x86/master
> >  git merge x86/mm
> >
> > and apply
> >
> > [PATCH] x86_64: check if Tom2 is enabled
> > http://lkml.org/lkml/2008/1/21/20
> > [PATCH] x86_64: update e820 instead of updating end_pfn v3
> > http://lkml.org/lkml/2008/1/21/19
> > [PATCH] x86_32: trim memory by updating e820 v2
> > http://lkml.org/lkml/2008/1/21/18
> >
> > YH
> >
> 
> Thanks, I am all patched up and ready to test, unfortunately one of my disks
> in my RAID 1 just died, I already filled out the advanced replacement form,
> I will test when I receive the replacement disk.

please get x86.git and apply
[PATCH] x86_32: trim memory by updating e820 v3
http://lkml.org/lkml/2008/1/22/394

Ingo already put other two into the tree.

Thanks

YH
