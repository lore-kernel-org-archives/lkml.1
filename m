Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbZHSIv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbZHSIv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 04:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZHSIv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 04:51:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62089 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZHSIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 04:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xpq5dzW1NzAlw+C47CwyWrTGeaePMT7tRCMXQ/c1S5eGmA6izR046tTC5m9bOuNDII
         C1l9CZ9Su2BwWHeDhAzkOR2fEJFzA27oGovokV7NhyefUuiIzwvs0cNyRKNVArn7qqF5
         heBP1+9HqC0+XsGvLCYU1pc9zI8KrBAaSZ69A=
MIME-Version: 1.0
In-Reply-To: <4A8B246D.7050004@dell.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
	 <1250631063.16393.14.camel@johannes.local> <4A8B246D.7050004@dell.com>
Date: Wed, 19 Aug 2009 09:51:24 +0100
Message-ID: <9b2b86520908190151p2bf136lb490ab721d320dad@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> Hi Guys:

Hi again Mario

> Alan Jenkins wrote:
>
>> ... but you *do* need to unregister wifi_rfkill here, before you go on
>> to destroy it.
>>
>> +err_wifi:
>> +	rfkill_destroy(wifi_rfkill);
>> +
>> +	return ret;
>> +}
>>
>> Regards
>> Alan
>>
> I think I've addressed this properly now and only go through each of the
> error handlers as necessary.

Yes, that looks better.  I'm still a bit confused about poll(), I'll
have to leave that for Johannes to verify.  Feel free to add

Reviewed-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Regards
Alan
