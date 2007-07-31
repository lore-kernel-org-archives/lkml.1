Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXGaHv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXGaHv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXGaHvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:51:52 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:14162 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXGaHvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:51:51 -0400
X-IronPort-AV: i="4.19,201,1183348800"; 
   d="scan'208"; a="36022354:sNHT50404760"
Subject: Re: early_printk accessing __log_buf
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@snapgear.com>, Russell King <rmk@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, Tim Bird <tim.bird@am.sony.com>,
       bryan.wu@analog.com
In-Reply-To: <8bd0f97a0707310047u51c6e46l7e57e8f7bfc4e858@mail.gmail.com>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	 <200707241350.45086.rgetz@blackfin.uclinux.org>
	 <20070724111215.8d91dc7c.akpm@linux-foundation.org>
	 <200707241612.56509.rgetz@blackfin.uclinux.org>
	 <20070724143004.6325a511.akpm@linux-foundation.org>
	 <8bd0f97a0707310047u51c6e46l7e57e8f7bfc4e858@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 31 Jul 2007 15:59:34 +0800
Message-Id: <1185868774.20043.17.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 31 Jul 2007 07:51:49.0811 (UTC) FILETIME=[A6CF9830:01C7D347]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 03:47 -0400, Mike Frysinger wrote:
> On 7/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 24 Jul 2007 16:12:56 -0400 Robin Getz wrote:
> > > On Tue 24 Jul 2007 14:12, Andrew Morton pondered:
> > > > Oh well, it sounds like we need the super-duper fast version.  Keep it
> > > > as simple as possible, please.
> > >
> > > What about:
> > >
> > > int log_buf_copy(void *dest, int idx, size_t n);
> > >
> > > starting at index idx - copy n bytes to dest, return the number of bytes
> > > copied (in case there are not n bytes in the log_buf yet).
> >
> > Sounds sensible.  I'd make it return size_t and take a char* arg though.
> > Or just use `int' - size_t is a bit of a pain and this is all kernel-internal
> > anwyay.
> 
> attached
> -mike

why use attachment? You can just paste your patch in the email.

Thanks
- Bryan Wu
