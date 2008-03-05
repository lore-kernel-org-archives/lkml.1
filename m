Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbYCEX0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbYCEX0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765085AbYCEXZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:25:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764576AbYCEXZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:25:46 -0500
Date: Wed, 5 Mar 2008 15:24:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: implement dynamic base allocation
Message-Id: <20080305152450.167c9e8c.akpm@linux-foundation.org>
In-Reply-To: <20080304170307.GA29979@localhost.localdomain>
References: <20080304170307.GA29979@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 20:03:07 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> If gpio_chip->base is negative during registration, gpiolib requests
> dynamic base allocation. This is useful for devices being registered
> at run-time (in contrast to platform devices).
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/gpio/gpiolib.c |   42 ++++++++++++++++++++++++++++++++++++------
>  1 files changed, 36 insertions(+), 6 deletions(-)
> 

This conflicts in non-trivial ways with gpio-define-gpio_is_valid.patch. 
Could you please redo and retest against 2.6.25-rc3-mm1?

Thanks.

