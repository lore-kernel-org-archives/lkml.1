Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZC1Q1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZC1Q1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 12:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbZC1Q1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 12:27:37 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:34820 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754708AbZC1Q1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 12:27:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G3kk9Op622H0yaCaD8zxWG+2oP4BK/5u0SAj1Lc2U7O5I22o0xk1zuNbWe5g8SnpSwXT67u9YbwnxpsBa9X27TIocgR+9GqVW81/oq+Qd6KMZO+L93uwwvqEsGtvd7g064MG/a4UBQ6mwW8X1rUPXSAI1WfEp42WHmxK8i05eyw=  ;
X-YMail-OSG: AkuAyzoVM1kCq4GCTVYv2TCZRoSoalliD0X0xIT2CtBjMNvEcz4OEJ8i2w4MQ1ZrsqbMkUNtQVc.ZrmcYYovalir1j9uGxh9P1ghFglQ5t8CMYVbfsj207SyTy4IyjxV69AiITuTKfezrrfm2bx25._pxxnZJ5vtBoCbqfrleyq6wxroFaG44biSbsS3
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 04/58] move at91_ether's probe function to .devinit.text
Date: Sat, 28 Mar 2009 09:27:32 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@redhat.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>
References: <20090327232153.GA16348@pengutronix.de> <200903271709.38383.david-b@pacbell.net> <20090328063211.GA1041@pengutronix.de>
In-Reply-To: <20090328063211.GA1041@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903280927.32786.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Uwe Kleine-König wrote:
> 
> > In this series, you cc'd me on four OMAP drivers
> > (mmci-omap, mmci-omap-hs, omap-rng, omap_udc) which
> > I *know* that's a completely workable -- and far
> > preferable -- solution.  There might be others.
>
> So if I convert them to the alternative fix, you volunteer to test these
> patches?  (Or at least provide your Tested-and-Acked-by:?)

Sure, those four plus at91_ether.  I've got that hardware
sitting around, and it's just build-and-boot.



