Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZIBRYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZIBRYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZIBRYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 13:24:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41700 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752670AbZIBRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 13:24:38 -0400
Date: Wed, 2 Sep 2009 18:24:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] AB3100 regulator support v3
Message-ID: <20090902172438.GA1190@rakim.wolfsonmicro.main>
References: <1251756258-23917-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251756258-23917-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Are we running light with overbyte?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 12:04:18AM +0200, Linus Walleij wrote:
> This adds support for the regulators found in the AB3100
> Mixed-Signal IC.
> 
> It further also defines platform data for the ST-Ericsson
> U300 platform and extends the AB3100 MFD driver so that
> platform/board data with regulation constraints and an init
> function can be passed down all the way from the board to
> the regulators.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

This looks basically good - my only concern is if the initialisation
data supplied for the regulators is just setting up the things that can
be set up via the API or if there's other stuff going on (this was my
reason for the question I asked the other day).  If there's other stuff
being configured then I'm happy with the patch modulo the static thing.
