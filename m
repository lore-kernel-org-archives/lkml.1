Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYGNVBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYGNVBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbYGNVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:00:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:26653 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYGNVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G5vZSzzobfz8LvloDSmFPSaCG6+/Cau9Yb/Wd6JS8jYHzV45zvzoNEtTWoQZ9o2Rz7
         ZJ7ZMjv1MQL+Hjv4XwqwzIs6SBMDi1KNkSvMXwo5qD29ICNiTtaw08TtMuH/J8kXe44O
         qYzuJsSsYLtveEBifYUnTirlocsmEJS+oL4qQ=
Date: Tue, 15 Jul 2008 01:00:48 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 1/3] genclk: add generic framework for managing clocks.
Message-ID: <20080714210048.GA14889@doriath.ww600.siemens.net>
References: <20080708134242.GA6176@doriath.ww600.siemens.net> <20080708134336.GA6240@doriath.ww600.siemens.net> <20080712234823.e632c7f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080712234823.e632c7f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider this version of patch.

I've:
* cleaned up the points you have pointed at:
* * moved locks and list to genclk_ namespace
* * made them static
* * provided documentation for new API and a link to linux/clk.h
    as a doc for implemented API
* reworked lockdep handling to be more clean and error-prone
* some small fixes


-- 
With best wishes
Dmitry

