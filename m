Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZKSUUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZKSUUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZKSUUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:20:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59249
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756AbZKSUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:20:11 -0500
Date: Thu, 19 Nov 2009 12:20:28 -0800 (PST)
Message-Id: <20091119.122028.155178577.davem@davemloft.net>
To: mschiller@tdt.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] hso: memory leak in hso_serial_common_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1C487791B6A047B7A26F2B3C54BE0A70@mschille2>
References: <1C487791B6A047B7A26F2B3C54BE0A70@mschille2>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Martin Schiller" <mschiller@tdt.de>
Date: Thu, 19 Nov 2009 09:43:57 +0100

> This patch fixes a memory leak in the hso_serial_common_free()
> function.
> The tx_buffer of a serial device was never freed here.
> 
> Signed-off-by: Martin Schiller <mschiller@tdt.de>

All three of your patches have been severely corrupted by
your email client.  Sequences of one or more tab characters
have been converted in a single space, etc.

> 09:04:29.000000000 +0100
> @@ -2296,6 +2296,7 @@ static void hso_serial_common_free(struc
>  /* unlink and free TX URB */
>  usb_free_urb(serial->tx_urb);
>  kfree(serial->tx_data);
> + kfree(serial->tx_buffer);
> }
> 

This makes your changes unusable.

You've already gone through two iterations trying to submit
these bug fixes.  Please take some time out to verify that
your outging patches in emails can be received accurately
and applied by the receiver (send the patch to yourself
and try to apply it, for example).

Thanks.
