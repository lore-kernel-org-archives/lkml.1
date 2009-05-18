Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZERRSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZERRSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZERRSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:18:00 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:41701 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZERRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ODzoICXfRUctWE/xRnXgbvQetodQKg9Zw9AXkvWhGixN91QRTsWPepDk/KMLnUX4aL
         +pLGF4LGeEuBMCdfauuND47xqos4Z7LpxQa1wPaAkzEdXChRyoxlPz59IMWDZXgiYMZM
         NAnV6kv5O3CoJ/9GcE7q+aOZd4DRTaKFCrurg=
MIME-Version: 1.0
In-Reply-To: <20090518164440.2124a4fa@hyperion.delvare>
References: <63386a3d0905140129s5fd0f32cxde1114489678f012@mail.gmail.com>
	 <4A0BF776.9030301@compulab.co.il>
	 <63386a3d0905180722u282f0dd3ua62b119a1a6a97e8@mail.gmail.com>
	 <20090518164440.2124a4fa@hyperion.delvare>
Date: Mon, 18 May 2009 22:48:00 +0530
Message-ID: <5d5443650905181018j11b00a0ekf3b1bedd911fd10a@mail.gmail.com>
Subject: Re: [PATCH] MFD: Add U300 AB3100 core support v1
From: Trilok Soni <soni.trilok@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
       sameo@linux.intel.com, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

>>
>> Right now I lean toward the first alternative.
>
> Neither is correct. Simply use i2c_new_dummy() on the second I2C
> address, and keep a pointer to the instantiated i2c_client for future
> use. Don't forget to call i2c_unregister_device() in your .remove()
> method.
>

or simply look at drivers/mfd/twl4030-core.c for example :). TWL4030
is a single chip having four slave addresses over I2C.



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
