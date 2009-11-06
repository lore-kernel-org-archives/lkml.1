Return-Path: <linux-kernel-owner+w=401wt.eu-S1751481AbZKGKMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbZKGKMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 05:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZKGKMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 05:12:20 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55437 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZKGKMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 05:12:14 -0500
Subject: Re: [PATCH] leds-ss4200: Check pci_enable_device return
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org,
       Javier Martinez Canillas <martinez.javier@gmail.com>
In-Reply-To: <1255537247-17208-1-git-send-email-dave@sr71.net>
References: <1255537247-17208-1-git-send-email-dave@sr71.net>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 16:14:16 +0000
Message-Id: <1257524056.10592.11.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 09:20 -0700, Dave Hansen wrote:
> pci_enable_result is defined using the __must_check macro but
> leds-ss4200 is not checking the return value.
> 
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> Signed-off-by: Dave Hansen <dave@sr71.net>
> ---
>  drivers/leds/leds-ss4200.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)

Queued in the LED tree, thanks.

Richard

