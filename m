Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131Ab0ADXnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0ADXnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812Ab0ADXnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:43:16 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59269 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0ADXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:43:15 -0500
Subject: Re: [PATCH] kernel/time/jiffies.c: local symbols should be static
From: john stultz <johnstul@us.ibm.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F468@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F468@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 15:43:04 -0800
Message-ID: <1262648584.3237.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 11:59 -0500, H Hartley Sweeten wrote:
> The symbol 'clocksource_jiffies' is not exported and should be static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: John Stultz <johnstul@us.ibm.com>

Yep, clocksource_jiffies has stopped being used elsewhere, so this can
be cleaned up.

Acked-by: John Stultz <johnstul@us.ibm.com>

thanks
-john



> ---
> 
> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> index 5404a84..36d2d83 100644
> --- a/kernel/time/jiffies.c
> +++ b/kernel/time/jiffies.c
> @@ -55,7 +55,7 @@ static cycle_t jiffies_read(struct clocksource *cs)
>  	return (cycle_t) jiffies;
>  }
>  
> -struct clocksource clocksource_jiffies = {
> +static struct clocksource clocksource_jiffies = {
>  	.name		= "jiffies",
>  	.rating		= 1, /* lowest valid rating*/
>  	.read		= jiffies_read, 


