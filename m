Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYKZJSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYKZJSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKZJSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:18:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:22261 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYKZJS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:18:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kEvSbTKfZYoBWbKwuWVLpEpnXYOc7SLrpfrkgb7KCrLM2M2KGSilTq1Pa7gLCTD4HA
         tzEDy5eONmXkLU5dR52LEW98c4WEBDxqhE44VKGQakmJ9PIB5pnWEG//MIQIUcw7dOTp
         MAOk7kkIOKsagSzD/KNw2/+lLH2JLjpMQ+jU8=
Message-ID: <45a44e480811260118v440716bbqa8d37c8b696c148a@mail.gmail.com>
Date: Wed, 26 Nov 2008 04:18:27 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       "David Brownell" <david-b@pacbell.net>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <492D125D.5010607@teltonika.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <492D125D.5010607@teltonika.lt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 4:09 AM, Paulius Zaleckas
<paulius.zaleckas@teltonika.lt> wrote:
> Jaya Kumar wrote:
>>   * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
>>   *   implementation may not sleep
>>   * @dbg_show: optional routine to show contents in debugfs; default code
>> @@ -84,6 +86,9 @@ struct gpio_chip {
>>                                               unsigned offset, int value);
>>       void                    (*set)(struct gpio_chip *chip,
>>                                               unsigned offset, int value);
>> +     void                    (*set_bus)(struct gpio_chip *chip,
>> +                                             unsigned offset, int values,
>
> I think values should be unsigned
>

Okay, can do but it is unusual no? since set uses int value, i figured
set_bus should be similar right?

Thanks,
jaya
