Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXBVQqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXBVQqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXBVQqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:46:33 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:29579 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXBVQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RLoTQlHeVEfigI/CouMUYdJWd+hq3E9QP10rxudas2bYnhwkYLfmPB8ZRE6fj7QGDjipZxhXEDdEjK3tPpbSjpA4nOPP8mcpXZO44HdmYPoNbhOb0s9dicrWvAkk/uQE+e2VQoeVgyv2C3EtGXrNd8wq3fuBZOv+K65LqKCBDPA=
Message-ID: <d120d5000702220846s50f7de7bsb8c9c0fc024278fa@mail.gmail.com>
Date: Thu, 22 Feb 2007 11:46:31 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Arkadiusz Miskiewicz" <arekm@maven.pl>
Subject: Re: 2.6.21rc1 git usb mouse stops working after resume from ram
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <200702212314.56958.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702212314.56958.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Arkadiusz Miskiewicz <arekm@maven.pl> wrote:
> #
> # USB HID Boot Protocol drivers
> #
> CONFIG_USB_KBD=m
> CONFIG_USB_MOUSE=m

Please do not enable USB boot protocol drivers unless generic HID
driver is not working for you.

-- 
Dmitry
