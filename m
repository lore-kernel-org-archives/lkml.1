Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbZD1LTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbZD1LTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbZD1LTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:19:00 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:43774 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbZD1LS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:18:59 -0400
Subject: Re: [PATCH] regulator: Move regulator drivers to subsys_initcall()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <1240852878-8276-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1240852878-8276-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 12:18:57 +0100
Message-Id: <1240917537.14165.118.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 18:21 +0100, Mark Brown wrote:
> Regulators need to be available early in init in order to allow them
> to be available for consumers when requested. This is generally done
> by registering them at subsys_initcall() time but not all regulator
> drivers have done that. Convert these drivers to do so in order to
> mimimise future support.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/da903x.c             |    2 +-
>  drivers/regulator/fixed.c              |    2 +-
>  drivers/regulator/pcf50633-regulator.c |    2 +-
>  drivers/regulator/wm8400-regulator.c   |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 

Applied.

Thanks

Liam

