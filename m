Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362Ab0AHHa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0AHHa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 02:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934Ab0AHHa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 02:30:58 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:62292 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0AHHa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 02:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gcLET//Yok0YzZbOWmLs8xLAO4/ou9oXfu69cKSdFZjDect2GAEwnsF5LteKtHUiIl
         maoWS5ZHERAVyukdTTpSELDyqWdlHdXLvjm+H9DsM5GN7amh1h1LTY1ziEH+sqCJm76K
         xUm+18VK7kKwIxS90aY+IRz3WJC/9ZeZtUJvo=
MIME-Version: 1.0
In-Reply-To: <1262932348-2888-2-git-send-email-ben-linux@fluff.org>
References: <1262932348-2888-1-git-send-email-ben-linux@fluff.org> 
	<1262932348-2888-2-git-send-email-ben-linux@fluff.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 8 Jan 2010 15:30:36 +0800
Message-ID: <f17812d71001072330t7a9f7607v8b55b2fc346745e5@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: add gpio_lookup_chip() to get chip information 
	for gpio
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 2:32 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> Add a call to get the 'struct gpio_chip' pointer for a given gpio, so
> that core implementations which want to use gpiolib gpio numbering for
> things like mux configuration can get back to the gpio_chip that they
> registered without having to have their own list of gpio.
>
> This is especially useful for the Samsung S3C64XX series where the GPIO
> bank sizes can vary from 32 down to 3, making it difficult to store an
> array to convert a number to chip.
>

I think this is generally a good idea. Will most likely be useful to
pxa platforms as well. Not sure though if you want to export this
symbol as well since we do allow gpio chip drivers to be modules.
