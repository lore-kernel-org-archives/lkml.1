Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0CAOzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:55:49 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34237 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0CAOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SKWNG68hzVVFr7/7sf49pZtcrVDYOYbFHWnK2JbE+3DvRg5ex2YTPpW/cj9tbQlA1p
         fPl+06bzrS9x9aWzvmb/wA8fsoMN0ToU3bwM7/yYZ2viiUCukh4Z1yoW3beFj5JJX85a
         b4Vqxj8B5go1e4eDeiQzTnnySBoQVY0PGwEJk=
MIME-Version: 1.0
In-Reply-To: <808c8e9d1002261532v447d62dfna61d0b19493b6551@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	 <20100224184505.1d8d3380@droptest.queued.net>
	 <808c8e9d1002260947k281782al889db51e20073648@mail.gmail.com>
	 <20100226160716.1bd4e342@droptest.queued.net>
	 <808c8e9d1002261532v447d62dfna61d0b19493b6551@mail.gmail.com>
Date: Mon, 1 Mar 2010 08:55:44 -0600
Message-ID: <808c8e9d1003010655m4f31f3c2wcbe0c1c882ab202e@mail.gmail.com>
Subject: Re: [PATCH] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
From: Ben Gardner <gardner.ben@gmail.com>
To: Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lets see how the proposed changes I just sent off are received and go
> from there.

Based on the feedback from the other gpio patches, I'd like to do the following:
1) drop this patch (olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch)
2) drop the patch that caused this patch to be created
(cs5535_gpio-gpio_chipget-should-return-the-input-value.patch)
3) submit a new patch that contains the original change + the changes
needed to adjust input/output settings to follow the spirit of
gpiolib.

That way, there is one patch that fully fixes the issue and no window
where the OLPC MIC stuff is broken.

Ben
