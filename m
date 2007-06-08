Return-Path: <linux-kernel-owner+w=401wt.eu-S938459AbXFHMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938459AbXFHMcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937111AbXFHMcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:32:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50124 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936297AbXFHMcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:32:10 -0400
Subject: Re: [v4l-dvb-maintainer] drivers/media/dvb/b2c2/flexcop-dma.c uses
	PCI DMA API
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org,
       v4l-dvb-maintainer@linuxtv.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0706071147080.9347@shell2.speakeasy.net>
References: <Pine.LNX.4.64.0706062106150.30244@anakin>
	 <1181220656.4187.64.camel@gaivota> <46681040.2010003@linuxtv.org>
	 <1181225452.4187.111.camel@gaivota>
	 <Pine.LNX.4.58.0706071147080.9347@shell2.speakeasy.net>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 09:30:20 -0300
Message-Id: <1181305820.3877.52.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

> Here is a patch that does just option B.  I have a couple other
> patches too.

Tracking the flexcop, I've arrived on a similar patch to yours, but this
approach will duplicate some debug macros. This is somewhat ugly. Since
we need this fix for a late -rc, I think that the better for now is to
use an optional code on Makefile that will add flexcop-dma to
b2c2-flexcop only if flexcop pci support is selected. The end result is
very simple, and will solve the issue.

The final patch is this one:
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=ee9a55464446146acbe12556d6de12cad0ac18c7
 
Cheers,
Mauro

