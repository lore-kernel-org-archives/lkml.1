Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbZKYKOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbZKYKOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbZKYKOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:14:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54589 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751387AbZKYKOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:14:03 -0500
Date: Wed, 25 Nov 2009 10:14:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: lrg@slimlogic.co.uk, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, peter.de-schrijver@nokia.com,
       eduardo.valentin@nokia.com
Subject: Re: [PATCHv2 3/3] Define critical regulators as always_on
Message-ID: <20091125101407.GA17420@opensource.wolfsonmicro.com>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com> <1259143495-9480-4-git-send-email-ext-juha.1.keski-saari@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259143495-9480-4-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 12:04:55PM +0200, Juha Keski-Saari wrote:

> +	if (pdev->id == TWL4030_REG_VIO ||
> +		pdev->id == TWL4030_REG_VDD1 ||
> +		pdev->id == TWL4030_REG_VDD2 ||
> +		pdev->id == TWL4030_REG_VPLL1 ||
> +		pdev->id == TWL4030_REG_VINTANA1 ||
> +		pdev->id == TWL4030_REG_VINTANA2 ||
> +		pdev->id == TWL4030_REG_VINTDIG)
> +		c->always_on = true;

This would be a bit clearer and much more idiomatic as a switch
statement.
