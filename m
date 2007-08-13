Return-Path: <linux-kernel-owner+w=401wt.eu-S973850AbXHMRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973850AbXHMRkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973519AbXHMRis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:38:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:19568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945868AbXHMRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uNQ+FSjcd87NPANQGgppqX4u80ZiF3vgSG9mJ7nZdmbN34vqOTbdwM5OlsNdDSiin4Z3g2NK5re3WF1v2E+OphHjvZBdA3jL8ZxgPf8ayWcB9fueAs4v8iQL3gjeQ9RaASktPk5+aHWB9RqAy72kdMq082rQ2pzYRqL3bf2c8QI=
Message-ID: <31e679430708131038u291bc504k91d1f1ce39e43cd9@mail.gmail.com>
Date: Mon, 13 Aug 2007 13:38:37 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Steffen Koepf" <steffen.koepf@opaya.de>
Subject: Re: [PATCH] USB-Core, Kernel 2.6.22.2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070813162742.GA31804@chaph>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070813162742.GA31804@chaph>
X-Google-Sender-Auth: 202c51fabf8b5f6a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8/13/07, Steffen Koepf <steffen.koepf@opaya.de> wrote:
> Hello,
>
> there is a USB-Device Init-Problem with the Apacer AE161 USB-Cardreader,
> which contains the Chip AU6375. The Cardreader init fails in about 50%
> of system boots, with the following lines:
>
> usb 1-6: unable to read config index 0 descriptor/all
> usb 1-6: can't read configurations, error -71
> hub 1-0:1.0: Cannot enable port 6.  Maybe the USB cable is bad?
>
> The patch let's the kernel stay in the loop, the cardreader is detected
> properly and the loop is never executed more than two times. The second
> call of usb_control_msg succeeds always. Maybe it was the developer's
> goal of the loop to fix such things?

Could you repost your patch following what is said in
Documentation/SubmittingPatches ??

thanks

>
> cu,
>
> Steffen
>
>
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
