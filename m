Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab0B0FL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 00:11:29 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35336 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0B0FL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 00:11:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XrGqRi7QXhnoPoFSCp2mIJ2ZLEwRN0+IofHOFe7WdUs0Ao7JhHCviEI6OHEx3U1/nS
         Myen1oM1uTGdM+sw23fL8F0uHvu645S1xkUU+73SSWGHs/pDykE7eCwZ+FSsS5W2K2jK
         8gZFTK9Cg+lmFC3OPAtwlR2NofllzkT2ws0/w=
MIME-Version: 1.0
In-Reply-To: <20100226183944.56bfee13@droptest.queued.net>
References: <cover.1267225701.git.gardner.ben@gmail.com>
	 <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
	 <20100226183944.56bfee13@droptest.queued.net>
Date: Fri, 26 Feb 2010 23:11:26 -0600
Message-ID: <808c8e9d1002262111i62703fd0t300616bc742deec5@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
From: Ben Gardner <gardner.ben@gmail.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about something like the following for set_direction, so we're not
> comparing magic bits?
>
> /* gpio direction flags */
> #define GPIO_DIR_NONE 0
> #define GPIO_DIR_INPUT (1 << 0)
> #define GPIO_DIR_OUTPUT (1 << 1)

Sounds good and it looks like those macros aren't used anywhere else.
Maybe also add a define for inout?
#define GPIO_DIR_INOUT (GPIO_DIR_INPUT | GPIO_DIR_OUTPUT)

Ben
