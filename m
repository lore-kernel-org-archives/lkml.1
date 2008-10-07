Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYJGU53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYJGU53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYJGU5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:57:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36518 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756102AbYJGU5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:57:08 -0400
Date: Tue, 7 Oct 2008 15:57:07 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: huang ying <huang.ying.caritas@gmail.com>,
       Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
Message-ID: <20081007205707.GA13132@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080926200242.GC138671@sgi.com> <1222478495.28661.19.camel@yhuang-dev.sh.intel.com> <20080928150106.GA204845@sgi.com> <851fc09e0810020102j7c4f8896vd384f79617480317@mail.gmail.com> <20081002153403.GA153543@sgi.com> <20081003091012.GF27551@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003091012.GF27551@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 11:10:12AM +0200, Ingo Molnar wrote:
> * Russ Anderson <rja@sgi.com> wrote:
> > On Thu, Oct 02, 2008 at 04:02:00PM +0800, huang ying wrote:
> > > On Sun, Sep 28, 2008 at 11:01 PM, Russ Anderson <rja@sgi.com> wrote:
> > > >
> > > > efi_call_virt6() uses efi.systab->runtime->f.
> > > > My call needs to use uv_systab, not efi.systab.
> > > 
> > > Yes. efi_call_virt6() is tied with standard EFI runtime services, so
> > > it may be not suitable for your need. What you need is just to do
> > > calling convention converting, like efi_call6 does. So I think it is
> > > better to just use your current implementation.
> > > 
> > > Acked-by: Huang Ying <ying.huang@intel.com>
> > 
> > Thanks.  Ingo, that is the v2 version of the patchset.
> 
> ok - could you please resend the lot with all the Acked-by's in place? 
> (and with all the bits that are being objected left out)
> 
> 	Ingo

Resent on Friday.  Here are the links.

http://marc.info/?l=linux-kernel&m=122305331422380&w=2
http://marc.info/?l=linux-kernel&m=122305331522386&w=2
http://marc.info/?l=linux-kernel&m=122305331522389&w=2
http://marc.info/?l=linux-kernel&m=122305331622393&w=2
http://marc.info/?l=linux-kernel&m=122305331722396&w=2

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
