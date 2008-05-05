Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYEEIse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYEEIse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYEEIs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:48:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20917 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYEEIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:48:25 -0400
Date: Mon, 5 May 2008 10:48:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCH] modpost: i2c aliases need no trailing wildcard
Message-ID: <20080505104816.1f666613@hyperion.delvare>
In-Reply-To: <200805051009.06159.rusty@rustcorp.com.au>
References: <20080502203721.70c5dc09@hyperion.delvare>
	<200805051009.06159.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Mon, 5 May 2008 10:09:05 +1000, Rusty Russell wrote:
> On Saturday 03 May 2008 04:37:21 Jean Delvare wrote:
> > Hi all,
> >
> > [Once more with Sam's address fixed, sorry for the noise.]
> >
> > Not all device types need a wildcard at the end of their module
> > aliases. In particular, for i2c module aliases, the trailing wildcard
> > is not only unneeded, it could also cause the wrong driver to be
> > loaded.
> 
> Hi Jean,
> 
>    i2c would have been better using a terminator char after the device name.  
> The wildcard would then allow future extensions without having the current 
> potential confusion.

This has been discussed already:
http://lists.lm-sensors.org/pipermail/i2c/2008-April/003429.html

I understand that the idea of the trailing wildcard was to allow for
future extensions, however in the case of i2c I can't foresee any such
extension. On top of that, it really only matters for external drivers
(for in-tree drivers, if the alias format changes, the drivers will
also be updated so no harm done) and I don't think external drivers are
worth the effort and cost of anticipating a change which most certainly
will never happen.

> Still, there's nothing wrong with this patch, happy for you to send it.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
-- 
Jean Delvare
