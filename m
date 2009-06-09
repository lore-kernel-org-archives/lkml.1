Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZFIRHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZFIRHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZFIRHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:07:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60777 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756106AbZFIRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:07:21 -0400
Date: Tue, 9 Jun 2009 18:07:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Oskar Schirmer" <os@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>, Sascha Hauer <kernel@pengutronix.de>,
       linux-kernel@vger.kernel.org, Fabian Godehardt <fg@emlix.com>
Subject: Re: [PATCH 8/8] imx: serial: add IrDA support to serial driver
Message-ID: <20090609180738.10014627@lxorguk.ukuu.org.uk>
In-Reply-To: <20090609161817.GA17246@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
	<1244555211-15618-2-git-send-email-os@emlix.com>
	<1244555211-15618-3-git-send-email-os@emlix.com>
	<1244555211-15618-4-git-send-email-os@emlix.com>
	<1244555211-15618-5-git-send-email-os@emlix.com>
	<1244555211-15618-6-git-send-email-os@emlix.com>
	<1244555211-15618-7-git-send-email-os@emlix.com>
	<1244555211-15618-8-git-send-email-os@emlix.com>
	<1244555211-15618-9-git-send-email-os@emlix.com>
	<20090609160132.31265ffc@lxorguk.ukuu.org.uk>
	<20090609161817.GA17246@emlix.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, the path will be optimized away, but still
> the conditional statement is subjected to syntax
> and scope analysis and gcc will correctly complain
> that irda_inv_rx is not declared.

Why are only about half of them done this way rather than all ?

> peripheral register settings, because the old baud rate
> calculation was not accurate enough for IrDA use.
> That's why we introduced the approximation function
> (and finally generalised it into lib/).

Yes - I'm fine with that part.

Alan
