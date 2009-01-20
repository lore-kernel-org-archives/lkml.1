Return-Path: <linux-kernel-owner+w=401wt.eu-S1762907AbZATULK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762907AbZATULK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZATUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:10:55 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:39551 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995AbZATUKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:10:54 -0500
Subject: Re: [PATCH 1/5] regulator: Pass regulator init data as explict
 argument when registering
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 20:10:51 +0000
Message-Id: <1232482251.16911.296.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 13:37 +0000, Mark Brown wrote:
> Rather than having the regulator init data read from the platform_data
> member of the struct device that is registered for the regulator make
> the init data an explict argument passed in when registering. This
> allows drivers to use the platform data for their own purposes if they
> wish.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/bq24022.c            |    2 +-
>  drivers/regulator/core.c               |    5 +++--
>  drivers/regulator/da903x.c             |    3 ++-
>  drivers/regulator/pcf50633-regulator.c |    3 ++-
>  drivers/regulator/wm8350-regulator.c   |    2 +-
>  drivers/regulator/wm8400-regulator.c   |    2 +-
>  include/linux/regulator/driver.h       |    3 ++-
>  7 files changed, 12 insertions(+), 8 deletions(-)
> 

All applied.

Thanks

Liam

