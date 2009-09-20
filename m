Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZITWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZITWvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 18:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZITWvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 18:51:09 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51044 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZITWvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 18:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RTdwH4DwM1Fhybjp7emo8BK1WH5V/dNmNYNazoZlFxYgAuHqw3BmxrGSMXd7JCencZ
         8yO8titzEBwB6ZXwzXOZWSAlH2C4pcMaMNxmqWGAwtz6Nd8oTcZvS7MIMEbG6c+EgkG0
         pKSuk/2jNPMXGRm1x31E+mVv9oWha0K8ej7z4=
MIME-Version: 1.0
In-Reply-To: <20090920185824.GA23206@dreamland.darkstar.lan>
References: <4AB1C907.1070503@gmail.com>
	 <20090920162306.GA18214@dreamland.darkstar.lan>
	 <51f3faa70909201047x56313d99q7cdc49bcc4634b01@mail.gmail.com>
	 <20090920185824.GA23206@dreamland.darkstar.lan>
Date: Sun, 20 Sep 2009 16:51:10 -0600
Message-ID: <51f3faa70909201551k70ace90x2b25351bfc04c555@mail.gmail.com>
Subject: Re: asus_atk0110 not working on Asus P7P55D PRO
From: Robert Hancock <hancockrwd@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 12:58 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>> >> I'm guessing this board uses a different format than what the driver
>> >> is expecting. I'm attaching the gzipped decompiled DSDT from the
>> >> board, hopefully it's useful to somebody..
>> >
>> > Please try the following patch, it should detect the proper buffer size.
>> >
>>
>> Obviously something not quite right:
>
> Ah yes, the pointer for the output buffer was pointing to the wrong
> variable. Sorry for that ;)

Cool, seems to be working. Though the high and critical temperatures
seem a bit odd, but maybe that's what the BIOS actually reports:

atk0110-acpi-0
Adapter: ACPI interface
Vcore Voltage:      +1.18 V  (min =  +0.80 V, max =  +1.60 V)
+3.3V Voltage:      +3.44 V  (min =  +2.97 V, max =  +3.63 V)
+5V Voltage:        +5.18 V  (min =  +4.50 V, max =  +5.50 V)
+12V Voltage:      +12.21 V  (min = +10.20 V, max = +13.80 V)
CPU Fan Speed:     1080 RPM  (min =  600 RPM)
Chassis1 Fan Speed:   0 RPM  (min =  600 RPM)
Chassis2 Fan Speed:1464 RPM  (min =  600 RPM)
Power Fan Speed:      0 RPM  (min =    0 RPM)
CPU Temperature:    +32.5°C  (high = +45.0°C, crit = +45.5°C)
MB Temperature:     +31.0°C  (high = +45.0°C, crit = +46.0°C)
