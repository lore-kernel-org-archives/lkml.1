Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYGERNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYGERNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYGERNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:13:13 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:30595 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752007AbYGERNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:13:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XiV4jT6LSJCY/Nqcbv2KU2qAfW1RnMF7pXx6f4xxN0OZwMP2B2sU7Y6XtcbAp4pikb1XJnj0/wNRTgAKX15AQ6mVzaDwPnYrAaKuDUF7OOsA0EvJNWXCwu0JfPzM7vR50I4FPnzLo3e5JlIsJyhQEMLbboiS67Zdj2WzwJZobbs=  ;
X-YMail-OSG: TSkwzL4VM1k2TsJSBEOH_AOBHHVGHkciUQiAGmuA8Ok0LGyE8TmL93tgci2CYxEiWyFvVO_ujg.mA48o34yRpE4CITFFbENUTojfbF_e1A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Date: Sat, 5 Jul 2008 10:13:09 -0700
User-Agent: KMail/1.9.9
Cc: Takashi Iwai <tiwai@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <200807040954.34838.david-b@pacbell.net> <20080705083122.GA7026@doriath.ww600.siemens.net>
In-Reply-To: <20080705083122.GA7026@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051013.10078.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2008, Dmitry Baryshkov wrote:
> 
> > > I'm not sure whether it's a better fix at this moment.
> > 
> > Which platform is it which is trying to declare that it has
> > an implementation (HAVE_GPIO_LIB) of an interface that it
> > doesn't support (GENERIC_GPIO unset) ??
> 
> the powerpc with PPC_MPC52xx=y, PPC_MPC5200_GPIO=y

The most natural fix is to have the Kconfig for PPC_MPC52xx
select both GENERIC_GPIO and HAVE_GPIO_LIB.

- Dave
