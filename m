Return-Path: <linux-kernel-owner+w=401wt.eu-S1030313AbXBZQin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030313AbXBZQin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXBZQin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:38:43 -0500
Received: from tim.rpsys.net ([194.106.48.114]:53539 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbXBZQim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:38:42 -0500
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20070226161203.GD2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
	 <1172490091.5824.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
	 <20070226142157.GA2909@khazad-dum.debian.net>
	 <1172501357.5824.91.camel@localhost.localdomain>
	 <20070226152035.GB2909@khazad-dum.debian.net>
	 <20070226161203.GD2909@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 16:38:27 +0000
Message-Id: <1172507907.5824.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 13:12 -0300, Henrique de Moraes Holschuh wrote:
> @@ -1707,7 +1708,8 @@ static int brightness_write(char *buf)
>  
>  static int brightness_update_status(struct backlight_device *bd)
>  {
> -	return brightness_set(bd->props.brightness);
> +	return brightness_set((bd->props.fb_blank == FB_BLANK_UNBLANK)? 
> +				bd->props.brightness : 0);
>  }
>  
>  static struct backlight_ops ibm_backlight_data = {

Should we be looking at bd->props.power here too?

Richard

