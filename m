Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbZBBWm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbZBBWm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZBBWmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:42:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbZBBWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:42:49 -0500
Date: Mon, 2 Feb 2009 14:41:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, andy@openmoko.com
Subject: Re: [PATCH 1/3] pcf50633_charger: Fix typo
Message-Id: <20090202144155.8626a1c3.akpm@linux-foundation.org>
In-Reply-To: <20090127135238.6875.26314.stgit@fedora.yogi>
References: <20090127135238.6875.26314.stgit@fedora.yogi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 19:22:38 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> Cc: Andy Green <andy@openmoko.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> ---
>  drivers/power/pcf50633-charger.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
> index e988ec1..41aec2a 100644
> --- a/drivers/power/pcf50633-charger.c
> +++ b/drivers/power/pcf50633-charger.c
> @@ -199,7 +199,8 @@ static int adapter_get_property(struct power_supply *psy,
>  			enum power_supply_property psp,
>  			union power_supply_propval *val)
>  {
> -	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
> +	struct pcf50633_mbc *mbc = container_of(psy,
> +				struct pcf50633_mbc, adapter);
>  	int ret = 0;
>  
>  	switch (psp) {

This looks like it fixes a rather fatal bug?
