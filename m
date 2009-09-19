Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZISNVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZISNVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 09:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZISNVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 09:21:00 -0400
Received: from fifo99.com ([67.223.236.141]:44436 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbZISNVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 09:21:00 -0400
Subject: Re: [PATCH] Fix fn-key release events for Samsung Q320 laptop
From: Daniel Walker <dwalker@fifo99.com>
To: Nick Gasson <nick@nickg.me.uk>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <4AB48658.2080709@nickg.me.uk>
References: <4AB48658.2080709@nickg.me.uk>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 06:20:58 -0700
Message-Id: <1253366458.6699.51.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 08:20 +0100, Nick Gasson wrote:
> This adds a workaround for the missing fn-key release
> events on Samsung Q320 and similar laptops.
> 
> Tested extensively on my own laptop.
> 
> Signed-off-by: Nick Gasson <nick@nickg.me.uk>
> ---
>   drivers/input/keyboard/atkbd.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index c9523e4..56a6ffa 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -1630,6 +1630,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
>                  .driver_data = atkbd_samsung_forced_release_keys,
>          },
>          {
> +               .ident = "Samsung Q320/P320",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),

Your patch is whitespace damaged .. All the tabs have been removed from
your code, and the context code in the patch. That usually means the
patch can't be applied .. It can happen when you X copy&paste the patch
into an email. I'd use git-format-patch and git-send-email (since your
using git anyway..)

Daniel

