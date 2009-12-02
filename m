Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZLBUlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZLBUlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZLBUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:41:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38017 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754174AbZLBUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:41:16 -0500
Date: Wed, 2 Dec 2009 20:41:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Richard Purdie <rpurdie@rpsys.net>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-ID: <20091202204121.GB18311@rakim.wolfsonmicro.main>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
 <1259778235.3588.141.camel@odin>
 <20091202213131.1393a956.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202213131.1393a956.ospite@studenti.unina.it>
X-Cookie: This page intentionally left blank.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:31:31PM +0100, Antonio Ospite wrote:
> Liam Girdwood <lrg@slimlogic.co.uk> wrote:

> > Some regulators may not support voltage change (via hw design or
> > constraints) so set_voltage() will fail. We probably want to handle this
> > regulator type so we don't call set_voltage().

> Ok, I'll read more about the regulator framework to find out how to
> check regulator capabilities.

Checking for errors when counting and listing the voltages ought to
cover this.
