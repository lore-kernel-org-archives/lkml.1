Return-Path: <linux-kernel-owner+w=401wt.eu-S1764897AbXJOPQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764897AbXJOPQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762693AbXJOPP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:15:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760554AbXJOPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:15:58 -0400
Subject: Re: [build bug] error: 'VID_HARDWARE_GEMTEK' undeclared
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pexu@kapsi.fi,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <20071015111345.GA26777@elte.hu>
References: <20071015111345.GA26777@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Mon, 15 Oct 2007 13:11:56 -0200
Message-Id: <1192461116.5240.14.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Seg, 2007-10-15 às 13:13 +0200, Ingo Molnar escreveu:
> randconfig testing of latest -git found this build bug:
> 
> drivers/media/radio/radio-gemtek.c:557: error: 'VID_HARDWARE_GEMTEK' undeclared here (not in a function)

Thanks. I'm applying Pekka patch for Gemtek.

It should be noticed that the hardware field isn't used anymore on V4L
core, or at the drivers (except for initializing the field), so it is
better just to remove the field and all occurrences.

Cheers,
Mauro

