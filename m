Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbXKLKkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbXKLKkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXKLKkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:40:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40086 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXKLKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:40:13 -0500
Subject: Re: Problems using quickcam_messenger on ARM (FYI)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Hirschmann <mh@durtro.de>
Cc: jayakumar.video@gmail.com, Christian Magnusson <mag@mag.cx>, dtor@mail.ru,
       linux-kernel@vger.kernel.org, Thierry MERLE <thierry.merle@free.fr>
In-Reply-To: <4730A379.9060706@durtro.de>
References: <4730A379.9060706@durtro.de>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Nov 2007 08:39:51 -0200
Message-Id: <1194863992.8662.65.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Ter, 2007-11-06 às 18:25 +0100, Markus Hirschmann escreveu:
> Hello Kernel-Developer,
> 
> Module quickcam_messenger seems to be broken (tried 2.6.18 and 2.6.22)
> on 2 different NSLU2 (ARM). Picture is attached. Same kernel and module 
> can be used without any problems on x86 here. I don't have any ARM 
> device beside the NSLU2, so I cannot check.
> 
> The solution was to use Christian Magnusson's quickcam module. 
> Everything worked without any problem. Webcam is:

Hmm... you're mentioning the quickcam module, but some of your logs are
related to usbvideo driver.

On a quick glance, I didn't find anything that could explain your
troubles. It seems to be related to a wrong order at the output format
(for example, the driver is sending RGB, instead of BGR).

It may also be an issue at the userspace application that is using the
wrong logic to deal with Big Endian.

-- 
Cheers,
Mauro

