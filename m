Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZFVI3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZFVI3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZFVI3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:29:06 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:45041 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZFVI3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ej745K8SRjy0prQPtEPanb/GA2T6gxX3Nf9rHGRPaPO9PefwxYJI6uhNifbnSBGpuR
         vEAhujrTP0l3BWeG2Xf4UDbTwT1Fp+G5iZ0iMWri8e/bk+EFyN+g8pm1qEGOFam+MI+2
         UCWiAfMCPruivrMCn50XtUWQ/j3XrI9ONH3UM=
MIME-Version: 1.0
In-Reply-To: <7448ec710906210415v2d25a120m23c59b435e5267f2@mail.gmail.com>
References: <7448ec710906210415v2d25a120m23c59b435e5267f2@mail.gmail.com>
Date: Mon, 22 Jun 2009 11:29:07 +0300
Message-ID: <7448ec710906220129l54dda1e0o86cb5fc738c67500@mail.gmail.com>
Subject: A question about MUSB driver
From: Pablo Bitton <pablo.bitton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to all,

I have a question about "davinci_source_power()" function at
drivers/usb/musb/davinci.c
(http://lxr.linux.no/linux+v2.6.30/drivers/usb/musb/davinci.c#L170).

If I am not wrong, it is using "#ifdef CONFIG_MACH_DAVINCI_EVM" and
"machine_is_davinci_evm()"
macro to conditionally turn VBUS-controlling GPIO on and off,
depending on specific machine being DaVinci EVM.

Our team works on another DaVinci based board - that is based on the
EVM, but has different machine ID and uses
different GPIO for VBUS switching.

If we use "davinci.c" code without a change, it is compiled without
VBUS handling code at all, which is certainly not what we need.
How should we change the code/Makefile/build process to include VBUS
handling for out specific board?

Thanks in advance.
