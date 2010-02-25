Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab0BYLOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:14:30 -0500
Received: from mail-iw0-f202.google.com ([209.85.223.202]:55570 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0BYLO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DyLxjmSf2JYYTl99v/UA+pS+KWIpL3sxj/bemVABEC86Il/S36udSYoazVqnt8QoCi
         pK92FkxCdV50rVkanxpta3toTXCL+tgpvaWK8dKa/Rorg69agDQ5mFYMe4VZ4oviAEm5
         0UWNboEUaJQLg4HhNyIsbI1k7k/hEbr0PCnik=
MIME-Version: 1.0
In-Reply-To: <1266953763.32702.49.camel@quad>
References: <1266953763.32702.49.camel@quad>
Date: Thu, 25 Feb 2010 13:14:27 +0200
Message-ID: <94a0d4531002250314o4a1d08cclceb20e991c51d829@mail.gmail.com>
Subject: Re: [PATCH] omap2_mcspi.c: NULL pointer dereference
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Scott Ellis <scott@jumpnowtek.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Aaro Koskinen <Aaro.Koskinen@nokia.com>,
       spi-devel-general@lists.sourceforge.net,
       gumstix-users@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 9:36 PM, Scott Ellis <scott@jumpnowtek.com> wrote:
> Check spi->controller_state before dereferencing.
>
> Shows up NULL here when using spi_alloc_device()/spi_add_device()
> and spi_add_device() fails before spi_setup(). Calling spi_dev_put()
> on the leftover spi_device results in the error.

This should go to the linux-omap mailing list.

-- 
Felipe Contreras
