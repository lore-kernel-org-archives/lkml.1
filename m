Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYGXO1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYGXO1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYGXO0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:26:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41745 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751544AbYGXO0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:26:52 -0400
Date: Thu, 24 Jul 2008 15:26:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Enable WM97xx touchscreen sub-drivers by default
Message-ID: <20080724142650.GA5234@rakim.wolfsonmicro.main>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1216905308-4723-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1216906867-5058-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080724065756.55954c35@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724065756.55954c35@infradead.org>
X-Cookie: Dime is money.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 06:57:56AM -0700, Arjan van de Ven wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > Currently the support for each WM97xx touchscreen model is compiled
> > out by default, meaning that the default configuration when the

> this isn't normally how things are done; Linux is on a "off unless
> selected or unless it breaks booting" policy nowadays...

These options only be visible if the user has chosen to build the WM97xx
touchscreen driver which does the default thing already.  Within the
context of the driver these options are of the broken boot variety since
without at least one of them being enabled the driver will do nothing
except waste resources.

I really don't think it's sensible for the default configuration of the
driver to produce something totally non-functional.

> (and distributions don't follow "default" anyway, so don't worry about
> that part)

This change is a direct result of Ubuntu enabling the driver with all
the controllers compiled out.  This seems like a completely reasonable
thing for them to do - nothing in Kconfig suggests that it is mandatory
to enable at least one of the options and the existing default and help
text both suggest that it should be turned off.
