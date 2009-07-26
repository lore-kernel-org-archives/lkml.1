Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZGZJko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZGZJko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 05:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZGZJkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 05:40:43 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48885 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbZGZJkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 05:40:43 -0400
Subject: Re: [PATCH] regulator: da903x: add support for DA9030 BUCK2 with
 DVM
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: broonie@opensource.wolfsonmicro.com, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1248594842-23456-1-git-send-email-mike@compulab.co.il>
References: <1248594842-23456-1-git-send-email-mike@compulab.co.il>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 10:40:39 +0100
Message-Id: <1248601239.25964.883.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 10:54 +0300, Mike Rapoport wrote:
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/regulator/da903x.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
> index b8b89ef..fab755d 100644
> --- a/drivers/regulator/da903x.c
> +++ b/drivers/regulator/da903x.c
> @@ -367,24 +367,24 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
>  	.enable_bit	= (ebit),					\
>  }
>  

Looks fine but did not apply :-

Applying: regulator: da903x: add support for DA9030 BUCK2 with DVM
error: patch failed: drivers/regulator/da903x.c:367
error: drivers/regulator/da903x.c: patch does not apply
Patch failed at 0001 regulator: da903x: add support for DA9030 BUCK2 with DVM

Could you regenerate against the regulator tree for-next branch.

git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git

Thanks

Liam

