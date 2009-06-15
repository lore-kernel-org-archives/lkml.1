Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZFONHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZFONHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZFONHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:07:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33426 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751729AbZFONHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:07:04 -0400
Date: Mon, 15 Jun 2009 14:07:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Alek Du <alek.du@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
	gpio_alt_func features to GPIOLIB
Message-ID: <20090615130704.GA28044@rakim.wolfsonmicro.main>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615095023.GA19873@fluff.org.uk> <20090615100253.GC6106@sirena.org.uk> <20090615125025.GB19873@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615125025.GB19873@fluff.org.uk>
X-Cookie: For external use only.
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:50:25PM +0100, Ben Dooks wrote:
> On Mon, Jun 15, 2009 at 11:02:53AM +0100, Mark Brown wrote:

> > Since the proposed API just passes a value through to the driver for the
> > GPIO chip it looks generic enough - each chip can define whatever set of

> Yes, however I can see some horrible problems ahead as soon as people
> try and then try and standardise the values passed through this. The

I fully expect that if anyone tries to do that all the GPIO driver
authors will turn round and tell them not to be so silly.

> GPIO API was meant to be a lightweight way of allowing drivers at
> GPIOs, now everyone seems to want to push whatever they feel like in.

This doesn't feel heavyweight to me.  I think it's better to have this
sort of widely implemented stuff there in the framework rather than
having a large proportion of GPIO drivers having to implement their own
(very similar) APIs on the side - as soon as drivers start having to do
that they start feeling unpleasant.
