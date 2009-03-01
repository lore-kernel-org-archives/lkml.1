Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZCACxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZCACxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 21:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZCACw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 21:52:59 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:49029 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZCACw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 21:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BbYv7ZxluFlX7fYn+ttwe7gwuHRsMUH4pFO8ZNh8OfPf9Iut9VYRo5eEBDUZX080Oz
         l+VIQpczt/u/PSLOhLllTx9Aki2R9A9lixOEJ7hVxZZEtJVuMtNFUqdTNQvZwBh2vCM2
         oXJQ2cvnNeY6ViWwBs85GkNZXb6RE011hlVSk=
MIME-Version: 1.0
In-Reply-To: <20090228164126.ZZRA012@mailhub.coreip.homeip.net>
References: <20090225044730.GA9106@july> <87skly16gh.fsf@basil.nowhere.org>
	 <20090228164126.ZZRA012@mailhub.coreip.homeip.net>
Date: Sun, 1 Mar 2009 11:52:56 +0900
X-Google-Sender-Auth: 0ea7a22c294c601e
Message-ID: <9c9fda240902281852n32b41cc7ref61dff7d5c1249f@mail.gmail.com>
Subject: Re: [PATCH] Input notifier support
From: Kyungmin Park <kmpark@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 1, 2009 at 9:42 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Sun, Mar 01, 2009 at 12:34:38AM +0100, Andi Kleen wrote:
>> Kyungmin Park <kmpark@infradead.org> writes:
>>
>> > Some hardware doesn't connected with key button and led. In this case key should be connected with led by software. Of course each application can control it however it's too big burden to application programmer.
>> >
>> > So add input notifier and then use it at other frameworks such as led.
>> > Of course, other input device can use this one.
>> >
>> > Any commnets are welcome.
>>
>> It looks like the perfect interface for a password stealing root kit.
>>
>> Yes there are probably other ways to do this, but still this seems to
>> make it very easy.
>>
>
> We already have good interface for that. That's why you want to limit
> access to /dev/input/eventX ;) and not make it world-readable.
>

Hi Dmitry,

Could you tell me know which interface you're talking?
I agreed it's not good idea to pass key code value to drivers. it
caused security issues.

Thank you,
Kyungmin Park
