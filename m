Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZFXHV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZFXHV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZFXHVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:21:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:15630 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFXHVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SWlxaNaLrcxhadf+x7LNgfXPHDj5/G/mIgqRCby3zAof0wfrNZMdFeMjtzI22eiz4J
         fcFzsJl+MAmKO+tEvxw79WG9wlk7sHSvidVGU89p8AKtU+4xk+i9St7r42AqiAXyZxPK
         dH7eapBcvjTD4WXdC5Do98inmaamHX9hhENO0=
MIME-Version: 1.0
In-Reply-To: <241b8f7b0906230627v12f8a48ft46fcbb98986e80c7@mail.gmail.com>
References: <241b8f7b0906230627v12f8a48ft46fcbb98986e80c7@mail.gmail.com>
Date: Wed, 24 Jun 2009 12:51:48 +0530
Message-ID: <241b8f7b0906240021p55d1721bt3fc74f2af7734e66@mail.gmail.com>
Subject: Re: Not able to read USB speed and descriptor
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the devio.c,

  I have added  a case to return the speed and other descriptors,

call :
 ret = usb_control_msg(pRootHub, usb_sndctrlpipe(pRootHub, 0),
               USB_REQ_CLEAR_FEATURE, USB_RT_PORT, USB_PORT_FEAT_POWER,
               port_num + 1, NULL, 0, HZ);

The above call is returning err : -32 EPIPE.

The above call is working file for the rear port while the same is not
working for the fromt port.


Anythig am I missing ? I am testing it for mass stoage device...


Any inputs ? ,,,,,

On Tue, Jun 23, 2009 at 6:57 PM, Prabhu
Chawandi<prabhu.chavandi@gmail.com> wrote:
> Hi all,
>
>   I ma not able to read the USB descriptor and speeed, while I can
> read and write into the storage device..
>
> What might be the reason for that ?
>
> regards,
> Prabhu
>
