Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbZARNut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbZARNut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 08:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbZARNuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 08:50:39 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:52191 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757930AbZARNui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 08:50:38 -0500
Subject: Re: [PATCH] regulator: move bq24022 init back to module_init
 instead of subsys_initcall
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1232285547-6518-1-git-send-email-philipp.zabel@gmail.com>
References: <1232285547-6518-1-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 13:50:35 +0000
Message-Id: <1232286636.16911.155.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 14:32 +0100, Philipp Zabel wrote:
> This workaround was needed when regulator/ was not linked before both
> power/ and usb/otg/ in drivers/Makefile. Now that it is even linked
> before mfd/, this patch makes sure that bq24022 isn't probed before the
> GPIO expander is set up.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/regulator/bq24022.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 

Applied.

Thanks

Liam

