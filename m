Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbZAPMVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbZAPMVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbZAPMVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:21:35 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:56784 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZAPMVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:21:35 -0500
Subject: Re: [patch 2.6.29-rc] regulator: minor cleanup of virtual consumer
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david-b@pacbell.net, broonie@opensource.wolfsonmicro.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090115161301.c74a071b.akpm@linux-foundation.org>
References: <200901141316.27584.david-b@pacbell.net>
	 <20090115161022.2b11ed41.akpm@linux-foundation.org>
	 <20090115161301.c74a071b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 12:21:31 +0000
Message-Id: <1232108491.4934.382.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 16:13 -0800, Andrew Morton wrote:
> On Thu, 15 Jan 2009 16:10:22 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> --- a/drivers/regulator/virtual.c~regulator-minor-cleanup-of-virtual-consumer-fix
> +++ a/drivers/regulator/virtual.c
> @@ -226,6 +226,10 @@ static ssize_t set_mode(struct device *d
>  	unsigned int mode;
>  	int ret;
>  
> +	/*
> +	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
> +	 * will be shared with show_mode(), above.
> +	 */
>  	if (sysfs_streq(buf, "fast\n") == 0)
>  		mode = REGULATOR_MODE_FAST;
>  	else if (sysfs_streq(buf, "normal\n") == 0)
> _
> 

Applied.

Thanks

Liam

