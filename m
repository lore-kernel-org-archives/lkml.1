Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbXEGOCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbXEGOCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXEGOCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:02:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2649 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754298AbXEGOCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:02:21 -0400
Date: Mon, 7 May 2007 14:01:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 5/8] APM emulation driver for class batteries
Message-ID: <20070507140148.GC3868@ucw.cz>
References: <20070503213237.GE20067@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503213237.GE20067@zarina>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> ---
>  drivers/power/Kconfig     |    7 ++
>  drivers/power/Makefile    |    1 +
>  drivers/power/apm_power.c |  249 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 257 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/apm_power.c
> 

> +#ifdef current
> +#undef current /* it expands to get_current() */
> +#endif

Uff, now that's a dirty hack. Can you rename your variables? current
-> I?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
