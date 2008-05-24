Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbYEXRPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbYEXRPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYEXRPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:15:05 -0400
Received: from mail0.scram.de ([78.47.204.202]:37272 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYEXRPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:15:04 -0400
X-Spam-Score: -4.111
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <48384D13.6010608@scram.de>
Date: Sat, 24 May 2008 19:14:59 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Brownell <david-b@pacbell.net>, fabrizio.garetto@gmail.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>	<20080516193613.28030.13950.stgit@trillian.secretlab.ca>	<20080521151928.GA28857@polina.dev.rtsoft.ru>	<200805221905.32288.david-b@pacbell.net>	<fa686aa40805232326w35f455d1s274899160d47eccb@mail.gmail.com> <fa686aa40805240950ocd16b97y308a54c68efa28ef@mail.gmail.com>
In-Reply-To: <fa686aa40805240950ocd16b97y308a54c68efa28ef@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely schrieb:
> On Sat, May 24, 2008 at 12:26 AM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
>> On Thu, May 22, 2008 at 8:05 PM, David Brownell <david-b@pacbell.net> wrote:
>>> On Wednesday 21 May 2008, Anton Vorontsov wrote:
>>>>> +++ b/drivers/spi/spi_of.c
>>>> I think better placement for this is drivers/of, no?
>>> Yes please.
>> Okay, I wasn't sure.  Will do.
> 
> I'm having second thoughts about this.  I think this code is more SPI
> centric than it is OF centric.  ie. it is usable by all spi masters in
> an OF enabled system, but it is not usable by all OF devices in an SPI
> enabled system.  Or, in other words; it adds OF support to SPI, not
> the other way around.  I think drivers/spi is the right place for this
> to live.

Isn't the same true for drivers/of/gpio.c or drivers/of/of_i2c.c, as well?

Thanks,
Jochen
