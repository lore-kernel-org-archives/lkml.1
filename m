Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbZJZNph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbZJZNph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZJZNph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:45:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:26316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbZJZNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:45:36 -0400
Subject: Re: [PATCH] regulator: keep index within bounds in
 da9034_get_ldo12_voltage()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4AE589E7.7000504@gmail.com>
References: <4AE589E7.7000504@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 13:45:32 +0000
Message-ID: <1256564732.3530.344.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 12:37 +0100, Roel Kluin wrote:
> If selector equals ARRAY_SIZE(da9034_ldo12_data), that is one too
> large already.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/regulator/da903x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
> index aa224d9..f8c4661 100644
> --- a/drivers/regulator/da903x.c
> +++ b/drivers/regulator/da903x.c
> @@ -331,7 +331,7 @@ static int da9034_get_ldo12_voltage(struct regulator_dev *rdev)
>  static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
>  				     unsigned selector)
>  {
> -	if (selector > ARRAY_SIZE(da9034_ldo12_data))
> +	if (selector >= ARRAY_SIZE(da9034_ldo12_data))
>  		return -EINVAL;
>  	return da9034_ldo12_data[selector] * 1000;
>  }

Applied.

Thanks

Liam

