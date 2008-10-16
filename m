Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYJPOiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYJPOiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYJPOhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:37:55 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:46250 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYJPOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:37:54 -0400
X-BigFish: VPS-36(z21eWz1432R98dR936eQ1805M179dRzzzzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K8U5YP-01-511-01
Date: Thu, 16 Oct 2008 08:39:10 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
Message-ID: <20081016143910.GF19397@cosmic.amd.com>
References: <414861224052797@webmail58.yandex.ru> <20081015162143.GA19397@cosmic.amd.com> <48F725FF.6000709@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48F725FF.6000709@yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 16 Oct 2008 14:37:42.0279 (UTC) FILETIME=[BF029170:01C92F9C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/08 15:31 +0400, Dmitry Antipov wrote:
> Jordan Crouse wrote:
> 
> > Hmmm - this is an interesting regression.  Please remove
> > CONFIG_GEODE_MFGPT_TIMER=y from your 2.6.27 kernel and see if the
> > problem goes away. 
> 
> Unfortunately it doesn't help.

Okay - that has been the reason for breakage in the past, so you can't
blame me for trying. :)

Could you try a 2.6.26 kernel?  That will confirm that this is a new
addition to 2.6.27.

> > I have been running 2.6.26.5 on my system with no problems, but I'm
>  > embarrassed to admit that I haven't run anything newer in a while.
> 
> What system do you have?

I have a wide variety of platforms available.  The good (or bad?) thing
about Geode is that the hardware generally looks the same, give or take
a superIO here and there.  If this is really a problem with the PIT or
TSC, then it should break easily.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

