Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbZD1NXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbZD1NXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZD1NXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:23:05 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48957 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbZD1NXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:23:04 -0400
Subject: Re: [PATCH 2.6.30] regulator: Fix default constraints for fixed
 voltage regulators
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
In-Reply-To: <1240913378-22201-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1240913378-22201-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 14:23:00 +0100
Message-Id: <1240924980.14165.143.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 11:09 +0100, Mark Brown wrote:
> Default voltage constraints were being provided for fixed voltage
> regulator where board constraints were not provided but these constraints
> used INT_MIN as the default minimum voltage which is not a valid value
> since it is less than zero. Use 1uV instead.
> 
> Also set the default values we set in the constraints themselves since
> otherwise the max_uV constraint we determine will not be stored in the
> actual constraint strucutre and will therefore not be used.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

Applied.

Thanks

Liam

