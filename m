Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbXJaTQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbXJaTQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbXJaTQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:16:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:49446 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbXJaTQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BXxKLse5zANvE502sypcDxSK8fIB3UWqCGkLJsfGXvhPxn6rCy6OqFVNZwWnfRUtTsjmwu6Reg7cLj2Gjt42M/NrMP1S+D+9j+dtwyu4s890VNyaqIreUYeAsTcthU8uztQC5DelnOC7SZR4/1Em1moLrf55pPcc8f6o3Y2VpHU=
Message-ID: <8bd0f97a0710311216l25f89b37v356fd44d7c1999da@mail.gmail.com>
Date: Wed, 31 Oct 2007 14:16:07 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Cc: spi-devel-general@lists.sourceforge.net, bryan.wu@analog.com,
       "Sonic Zhang" <sonic.zhang@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200710311201.29643.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <200710310011.33545.david-b@pacbell.net>
	 <8bd0f97a0710310133m7b5cbbf3j545a489c401185df@mail.gmail.com>
	 <200710311201.29643.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 31 October 2007, Mike Frysinger wrote:
> > On 10/31/07, David Brownell <david-b@pacbell.net> wrote:
> > > (ISTR the M25P16 in $SUBJECT has two read commands, one of
> > > which is only usable at clock rates below 33 MHz or so, but
> > > most other commands can work above that speed just fine.)
> >
> > pretty much all SPI flashes have two read commands ("slow" and "fast"
> > as they're typically called).
>
> Not DataFlash.

doesnt it ?  AT45DB642D says 0x0B is fast (up to 66mhz) while 0x03 (up to 33mhz)
-mike
