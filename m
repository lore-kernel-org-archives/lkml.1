Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbYB1AnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbYB1AnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbYB1AnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:43:01 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:44352 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758221AbYB1AnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:43:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=irmQgmVcSIa+mi/DGHzAF1gGcSiCIHWIpJSXHe/zoWiN1BP2eqyWpw/g7zbnYhy7l2+x0/b4mjB7BAnzgemmUjeFtWCgT7DsLkG9/gn0vPLgZiQG0gNTrXAjBHbpbwn9SFlnrr6yOQv7uCzRCOCtAEg23rD89RM6NgbQ0g/PqkM=  ;
X-YMail-OSG: .JFq8rAVM1lt4QpGDRkYAOp9CyLibr36ynjQxl_ZOtftbbuHnVGVgyqmgDAbbEzuH.2w5V0Dww--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.25-rc2-git] gpio:  <linux/gpio.h> and "no GPIO support here" stubs
Date: Wed, 27 Feb 2008 16:42:57 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, cbouatmailru@gmail.com,
       avorontsov@ru.mvista.com, florian.fainelli@telecomint.eu
References: <200802221712.17815.david-b@pacbell.net> <20080227154854.6ee9432c.akpm@linux-foundation.org>
In-Reply-To: <20080227154854.6ee9432c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271642.57895.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Add a <linux/gpio.h> defining fail/warn stubs for GPIO calls on platforms
> > that don't support the GPIO programming interface.  That includes the
> > arch-specific implementation glue otherwise.
> > 
> > This facilitates a new model for GPIO usage:  drivers that can use GPIOs
> > if they're available, but don't require them.  ...
> > 
> 
> Looks sane.
> 
> > Please include before 2.6.25-final ...
> 
> For what reason?

So that 2.6.25 based systems can start to use it.  This patch is in that
"safe, can't break any existing code" category, so I don't see a downside.

- Dave


