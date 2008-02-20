Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbYBTRzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbYBTRzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbYBTRzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:55:06 -0500
Received: from mail.hevs.ch ([153.109.23.10]:52690 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761395AbYBTRzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:55:04 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] atmel_spi: support zero length transfer
Date: Wed, 20 Feb 2008 18:55:01 +0100
User-Agent: KMail/1.9.7
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080221.005432.07645461.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201855.02605.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wednesday 20 February 2008, you wrote:
> A spi transfer with zero length is not invalid.  Such transfer can be
> used to achieve delay before first CLK edge after chipselect assertion.
How long will be that delay?

If they are really users of that kind of thing, this should be fixed by adding
a "delay_us_before_xfer" field in the  struct spi_transfer.

Have you tested it? I think if you start a transfer with 0 len, the ENDRX bit
will never rise, however, I'm not sure about this.

Regards

Marc
