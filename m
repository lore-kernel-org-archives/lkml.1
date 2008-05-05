Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYEEAJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYEEAJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 20:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYEEAJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 20:09:14 -0400
Received: from ozlabs.org ([203.10.76.45]:54355 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbYEEAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 20:09:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] modpost: i2c aliases need no trailing wildcard
Date: Mon, 5 May 2008 10:09:05 +1000
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Linux I2C <i2c@lm-sensors.org>
References: <20080502203721.70c5dc09@hyperion.delvare>
In-Reply-To: <20080502203721.70c5dc09@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051009.06159.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008 04:37:21 Jean Delvare wrote:
> Hi all,
>
> [Once more with Sam's address fixed, sorry for the noise.]
>
> Not all device types need a wildcard at the end of their module
> aliases. In particular, for i2c module aliases, the trailing wildcard
> is not only unneeded, it could also cause the wrong driver to be
> loaded.

Hi Jean,

   i2c would have been better using a terminator char after the device name.  
The wildcard would then allow future extensions without having the current 
potential confusion.

Still, there's nothing wrong with this patch, happy for you to send it.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
