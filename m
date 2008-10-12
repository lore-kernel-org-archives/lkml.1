Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYJLQH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYJLQH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 12:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYJLQHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 12:07:14 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:58966 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYJLQHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 12:07:13 -0400
Date: Sun, 12 Oct 2008 18:07:13 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] atmel-mci: support multiple mmc slots
Message-ID: <20081012180713.049aa297@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081012175853.0d75b78f@mjolnir.drzeus.cx>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
	<20081012103958.7905356b@mjolnir.drzeus.cx>
	<20081012151344.3f81ac75@hskinnemo-gx745.norway.atmel.com>
	<20081012175853.0d75b78f@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Oct 2008 16:06:57.0778 (UTC) FILETIME=[8D7BDD20:01C92C84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> > It can happen if the controller is hooked up to a fast bus and fOD is
> > slow for whatever reason. And if it does, clkdiv will wrap around and
> > end up at a rate much faster than requested, so saturating it at the
> > maximum divider is the safe thing to do.
> >   
> 
> Isn't this calculated for f_min though so that the MMC core will never
> request such a frequency?

Hmm...yes, you're probably right. Still, I think it's a nice safety net
if someone manages to mess up f_min or starts doing more aggressive
frequency scaling.

Haavard
