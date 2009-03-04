Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbZCEAAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbZCEAAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 19:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZCEAAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 19:00:01 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:29138 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbZCEAAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 19:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G+y01IP8sfEpGEvUEJyx0aTHMTNas0x7oCnQWElo8JsOcwrBFbcvVSwjc4XhcOxxqE
         GBpyEfXDHmdRToiH3K0GXyAqy0WeWu6Ru9r1H1cCCqTG5TQI6IVjJmI8baENwAoml2fk
         ctlcUwo4JMKR01vK/2PzC/Lngpi/Ppg+BbY6o=
MIME-Version: 1.0
In-Reply-To: <49AE4A2E.8090300@gmail.com>
References: <43e72e890903021737v7f5c4f06lb13e4f5d3ad67fd7@mail.gmail.com>
	 <43e72e890903021751m3f17206dge880dfc4d2c56711@mail.gmail.com>
	 <49AD17DD.1030206@gmail.com>
	 <43e72e890903031607k4e2ce36csb7c48de2f01a6de6@mail.gmail.com>
	 <43e72e890903031738w12a726d4ga3f998d8e4263a73@mail.gmail.com>
	 <49AE4A2E.8090300@gmail.com>
Date: Wed, 4 Mar 2009 15:59:58 -0800
Message-ID: <43e72e890903041559s4bfce44as5a2071f71d47ae15@mail.gmail.com>
Subject: Re: hid-dummy.ko Input/output error -- causing huge delays
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 1:30 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 4.3.2009 02:38, Luis R. Rodriguez wrote:
>>
>> Well now I see FC10 say its starting udev and it just sits there
>> waiting for the same period of time so maybe it was that (?). But at
>> the console the hid-dummy is not the last message I see now, but I
>> guess I wouldn't because it returns 0 now huh.
>
> Sorry, I'm totally confused now :). What you wouldn't?

Hm?

Let me explain what I am concluding:

Whether or not return -EIO is used for the hid_dummy on my FC10 box I
get huge delay during bootup when starting udev. It sits there and
says:

Starting udev:

If hid-dummy return -EIO then immediately afterwards I see the error
for inserting it with the EIO error explained:

FATAL: Error inserting hid_dummy
(/lib/modules/2.6.29-rc7-wl/kernel/drivers/hid/hid-dummy.ko):
Input/output error

> Actually I saw similar behavior on one of my boxes. I'll recheck if it is
> still present.

Oh nice. Yeah so the huge delay seems to be unrelated to hid-dummy.

  Luis
