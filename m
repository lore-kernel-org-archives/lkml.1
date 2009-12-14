Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZLNAg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZLNAg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZLNAgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:36:25 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:45899 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737AbZLNAgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:36:24 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2009 19:36:23 EST
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200912140027.nBE0R1V9013092@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH 10/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
To: re.emese@gmail.com
Date: Mon, 14 Dec 2009 10:57:01 +1030 (CST)
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, tony@linx.net,
       jwoithe@physics.adelaide.edu.au, torvalds@linux-foundation.org
In-Reply-To: <d9e382d265c6c101d536284758dc8b6cb608ab6b.1260662995.git.re.emese@gmail.com> from "re.emese@gmail.com" at Dec 14, 2009 12:59:02 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> From: Emese Revfy <re.emese@gmail.com>
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index bcd4ba8..a249b35 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -436,7 +436,7 @@ static int bl_update_status(struct backlight_device *b)
>  	return ret;
>  }
>  
> -static struct backlight_ops fujitsubl_ops = {
> +static const struct backlight_ops fujitsubl_ops = {
>  	.get_brightness = bl_get_brightness,
>  	.update_status = bl_update_status,
>  };

I have no problem with this,  If this is the "accepted" convention here then
let's go for it.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

Regards
  jonathan
