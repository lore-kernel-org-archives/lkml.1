Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbYA1WYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbYA1WYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYA1WXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:23:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbYA1WXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:23:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make suspend_device() static
Date: Mon, 28 Jan 2008 23:21:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20080128221024.GO8767@does.not.exist>
In-Reply-To: <20080128221024.GO8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282321.25567.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Adrian Bunk wrote:
> suspend_device() can become static.

That's correct.  I'll push the patch to Len.

> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 344fcfcea0df8cbaa83e10d7e66b826ead67290b 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 200ed5f..cfcc54f 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -414,7 +414,7 @@ EXPORT_SYMBOL_GPL(device_power_down);
>   *	@dev:	Device.
>   *	@state:	Power state device is entering.
>   */
> -int suspend_device(struct device *dev, pm_message_t state)
> +static int suspend_device(struct device *dev, pm_message_t state)
>  {
>  	int error = 0;
>  
> 
