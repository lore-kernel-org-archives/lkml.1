Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbXCEC0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbXCEC0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbXCEC0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:26:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:42174 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbXCEC0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:26:33 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 5 Mar 2007 13:25:18 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <17899.32654.441273.208962@notabene.brown>
Cc: <jamagallon@ono.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
In-Reply-To: message from Andrew Morton on Sunday March 4
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070305011133.570a9ba8@werewolf-wl>
	<20070304171737.42c14570.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday March 4, akpm@linux-foundation.org wrote:
> On Mon, 5 Mar 2007 01:11:33 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:
> 
> > On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > Temporarily at
> > > 
> > >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > > 
> > > Will appear later at
> > > 
> > >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> > > 
> > 
> > nfs blocks shutdown and reboot.
> > If I try to do 'service nfs stop', the box hangs, no login, no SysRQ-T or P,
> > S-U-B works at least.
> > 
> 
> The bug was added by
> knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch.

Bother.......
Looks like a need a MSG_DONTWAIT in there, don't I.

I'll resend.

Thanks,
NeilBrown
