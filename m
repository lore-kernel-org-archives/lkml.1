Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZLCAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZLCAKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 19:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZLCAKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 19:10:18 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33673 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZLCAKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 19:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gZysjcGKNANpC0La6Ut2uaJODm83UhjQPU5ulHbc/1RefMCawPXH/fX4ZzVA7eh3WH
         KKTNjoh1rtDxsUVsWz3CGPhg/kCcU4MTibz6I0HPjDrnii1nYF/tDKb4WrLFgSVzcjwr
         wYPeYImM9wQpqYjMrQoVaqpXosQFQoAx53gSE=
Message-ID: <4B1701EC.9030504@gmail.com>
Date: Wed, 02 Dec 2009 18:10:20 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux-usb <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: root hub lost power or was reset
References: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com>
In-Reply-To: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 04:34 PM, Justin Mattock wrote:
> I've been getting a 45 sec
> pause when waking my machine up
> on the first cycle using s2ram.
> At first thought it was udev, but later
> am not sure it is. With further looking
> if I remove the isight_firmware module from the kernel
> suspend wakes up the first cycle as it should.(I don't have
> isight-firmware-tools installed, leading me to believe this might
> be the issue with isight-firmware.ko.)
>
> Now looking at dmesg I see:
>
> [  413.551845] uhci_hcd 0000:00:1d.0: PCI INT A ->  GSI 23 (level, low) ->  IRQ 23
> [  413.551855] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [  413.551887] usb usb2: root hub lost power or was reset

Is that unexpected? It seems reasonable to me..
