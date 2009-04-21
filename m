Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZDURuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZDURuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZDURtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:49:46 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:37162 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZDURto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:49:44 -0400
Subject: Re: [BUILD FAILURE 03/04] Next April 21 : x86_64 randconfig
 [fs/nfs/nfs.ko]
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Benny Halevy <bhalevy@panasas.com>
Cc: subrata@linux.vnet.ibm.com, NFS list <linux-nfs@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49EE056C.1060605@panasas.com>
References: <1240332715.9110.39.camel@subratamodak.linux.ibm.com>
	 <49EE056C.1060605@panasas.com>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 13:49:32 -0400
Message-Id: <1240336172.20441.0.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: D1C2692EFD6551BE54EC5D8852223AADF784EAC0
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 2 total 181 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 20:42 +0300, Benny Halevy wrote:
> On Apr. 21, 2009, 19:51 +0300, Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> > I think i am observing this for the first time in any randconfig builds:
> > 
> > BUILD   arch/x86/boot/bzImage
> > Root device is (8, 3)
> > Setup is 13020 bytes (padded to 13312 bytes).
> > System is 5625 kB
> > CRC a80d60ee
> > Kernel: arch/x86/boot/bzImage is ready  (#1)
> >   Building modules, stage 2.
> >   MODPOST 514 modules
> > ERROR: "find_last_bit" [fs/nfs/nfs.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > ---
> > 
> > Regards--
> > Subrata
> > 
> 
> Trond, can you please merge
> http://git.linux-nfs.org/?p=bhalevy/linux-pnfs.git;a=commitdiff;h=9f32944d1bca79038ef3e9c9a27f11803d093d8e
> into your nfsv41 and linux-next branches?
> 
> I've placed it right before "nfs41: free slot"
> in git://git.linux-nfs.org/projects/bhalevy/linux-pnfs.git nfs41-for-2.6.31
> 
> (see also this thread:
> http://article.gmane.org/gmane.linux.kernel.next/6951)

Could we just push that straight into the kernel? It seems like a
no-brainer...

Cheers
  Trond

