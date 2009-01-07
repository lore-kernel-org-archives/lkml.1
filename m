Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZAGOJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZAGOJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZAGOJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:09:25 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:32320 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZAGOJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:09:24 -0500
Date: Wed, 7 Jan 2009 15:09:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@openedhand.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc 2/2] move drivers/i2c/chips/menelaus.c to
 drivers/mfd
Message-ID: <20090107150911.10e0dcd7@hyperion.delvare>
In-Reply-To: <200812170129.44972.david-b@pacbell.net>
References: <200812170129.44972.david-b@pacbell.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 17 Dec 2008 01:29:44 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Move the menelaus driver from drivers/i2c/chips to drivers/mfd
> since it's more of a multi-function device than anything else,
> and since Jean is trying to vanish drivers/i2c/chips ASAP.
> 
> One way to think of these chips are as the PMIC family most
> used with OMAP2 generation chips.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/i2c/chips/Kconfig    |   10 
>  drivers/i2c/chips/Makefile   |    1 
>  drivers/i2c/chips/menelaus.c | 1285 -----------------------------------------
>  drivers/mfd/Kconfig          |   10 
>  drivers/mfd/Makefile         |    1 
>  drivers/mfd/menelaus.c       | 1285 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 1296 insertions(+), 1296 deletions(-)

I see that this patch and the tps65010 one have been applied already.
Thank you for doing this!

-- 
Jean Delvare
