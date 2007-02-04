Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbXBDDM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbXBDDM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 22:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXBDDM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 22:12:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:51719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbXBDDM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 22:12:28 -0500
Date: 04 Feb 2007 04:04:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: vincent.vanackere@gmail.com
cc: linux-input@atrey.karlin.mff.cuni.cz
cc: linux-kernel@vger.kernel.org
cc: penberg@cs.helsinki.fi
Message-ID: <AAEizONrB9B@bartelmus.de>
In-Reply-To: <65258a580702020304m52283349ne4ba2895d9ce7188@mail.gmail.com>
Subject: Re: [PATCH] lirc: remove backwards compatibility macro obfuscation
User-Agent: OpenXP/4.0.7330 (Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:284c5d0e30cf020a3f9a09292c25b7b4
X-Provags-ID2: V01U2FsdGVkX18FEVA82CBqI9kQIRcn5VfIViwSeo5EzdBdzF/hZDhxljUmOfi47bIn7PqDVTCjcFP8iAh1ph8FIrm4ZxjKDnNjrGBKtPdmmcdMskQxKZLo6PbdBspbyPWY
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

on 02 Feb 07 at 12:04, you wrote:
> On 2/2/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>  [...]
>>  drivers/lirc_atiusb/lirc_atiusb.c           |  102 -----------------
>                               ^^^^^^^^^^^^^^
>
>  I may be mistaken, but the lirc_atiusb module looks redondant with
> the driver already in drivers/usb/input/ati_remote.c.
> Moreover, I was under the impression that the input layer was
> currently considered the "right way" to implement the kernel side lirc
> needs

No. Using the input layer makes no sense for most lirc drivers. The  
hardare used does not decode the IR signals itself but only provides raw  
signal timings. Those signals are decoded in userspace by lircd.
It would be a really bad idea trying to do this decoding in kernel  
space.

Christoph
