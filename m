Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYJBPeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYJBPeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYJBPeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:34:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42827 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754300AbYJBPeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:34:10 -0400
Date: Thu, 2 Oct 2008 10:34:09 -0500
From: Russ Anderson <rja@sgi.com>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
Message-ID: <20081002153403.GA153543@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080926200242.GC138671@sgi.com> <1222478495.28661.19.camel@yhuang-dev.sh.intel.com> <20080928150106.GA204845@sgi.com> <851fc09e0810020102j7c4f8896vd384f79617480317@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <851fc09e0810020102j7c4f8896vd384f79617480317@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 04:02:00PM +0800, huang ying wrote:
> On Sun, Sep 28, 2008 at 11:01 PM, Russ Anderson <rja@sgi.com> wrote:
> >
> > efi_call_virt6() uses efi.systab->runtime->f.
> > My call needs to use uv_systab, not efi.systab.
> 
> Yes. efi_call_virt6() is tied with standard EFI runtime services, so
> it may be not suitable for your need. What you need is just to do
> calling convention converting, like efi_call6 does. So I think it is
> better to just use your current implementation.
> 
> Acked-by: Huang Ying <ying.huang@intel.com>

Thanks.  Ingo, that is the v2 version of the patchset.

> Best Regards,
> Huang Ying

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
