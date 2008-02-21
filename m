Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYBUJ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYBUJ0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYBUJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:26:19 -0500
Received: from mail.hevs.ch ([153.109.23.10]:38925 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYBUJ0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:26:17 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] atmel_spi: support zero length transfer
Date: Thu, 21 Feb 2008 10:26:16 +0100
User-Agent: KMail/1.9.7
Cc: hskinnemoen@atmel.com, david-b@pacbell.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp> <200802201855.02605.marc.pignat@hevs.ch> <20080221.105233.41199605.nemoto@toshiba-tops.co.jp>
In-Reply-To: <20080221.105233.41199605.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211026.17816.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Thursday 21 February 2008, Atsushi Nemoto wrote:
...
> Yes.  I tested it on AT91SAM9260 and it seems ENDRX rises soon.
> Though it can be possible to avoid starting DMA for zero length
> transfer, I think it is not worth to optimize for such a rare case.
Ok, verified to work on at91rm9200, should be tested on AVR32.

David, do you think writing 0 bytes is a valid use of this API?
IMHO, we should add a fied to the spi_transfer struct.

Regards

Marc

