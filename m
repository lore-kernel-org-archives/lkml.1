Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbZHZPWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbZHZPWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbZHZPWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:22:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:53619 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZHZPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:22:43 -0400
Subject: Re: [PATCH] REGULATOR Handle positive returncode from enable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251284044-29252-1-git-send-email-linus.walleij@stericsson.com>
References: <1251284044-29252-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 16:22:40 +0100
Message-Id: <1251300160.8158.44.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 12:54 +0200, Linus Walleij wrote:
> This makes _regulator_enable() properly handle the case where
> a regulator is already on when you try to enable it. Currently
> it will erroneously handle positive return values as an error.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/regulator/core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 

Applied.

Thanks

Liam

