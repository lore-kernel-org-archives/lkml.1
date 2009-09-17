Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbZIQJRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbZIQJRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZIQJRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:17:42 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37574 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZIQJRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DH1dKxQCEifpZ4KCnOgMNcNBofO5WmPHm1l7oeauRzXQ6ys+0l7rnJhwQBjtVmGCoC
         /nuZi1mwdqxiEEe9T6uMuLFxWwgtU++rBG31FwqMTJmxEa+8048gzoU15Ubxazf0h4+B
         pCPuCZGxcmW37LNuBa2Mf/tp3t9Y3wEjMQyeg=
MIME-Version: 1.0
In-Reply-To: <4AB1C907.1070503@gmail.com>
References: <4AB1C907.1070503@gmail.com>
Date: Thu, 17 Sep 2009 11:17:42 +0200
Message-ID: <68676e00909170217y8819e3dv115fd6c987942495@mail.gmail.com>
Subject: Re: asus_atk0110 not working on Asus P7P55D PRO
From: Luca Tettamanti <kronos.it@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 7:28 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Just built a new system with an Asus P7P55D PRO motherboard. The ATK0110
> driver doesn't seem to be able to retrieve any hardware monitoring
> parameters successfully, sensors gives:
>
> atk0110-acpi-0
> Adapter: ACPI interface
> ERROR: Can't get value of subfeature in0_input: I/O error
> Vcore Voltage:      +0.00 V  (min =  +0.80 V, max =  +1.60 V)
> ERROR: Can't get value of subfeature in1_input: I/O error
> +3.3V Voltage:      +0.00 V  (min =  +2.97 V, max =  +3.63 V)
> ERROR: Can't get value of subfeature in2_input: I/O error
> +5V Voltage:        +0.00 V  (min =  +4.50 V, max =  +5.50 V)
>
> etc. and dmesg spits out a bunch of these:
>
> ATK0110 ATK0110:00: atk_read_value_new: ACPI exception: AE_BUFFER_OVERFLOW

Hum, they changed the output buffer size. I'm working on a fix.

Luca
