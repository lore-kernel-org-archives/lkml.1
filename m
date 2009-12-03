Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbZLCIPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbZLCIPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZLCIPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:15:44 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:39385 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZLCIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=h+ItZikiETRejsBwBVCXYtL1l2z1oxQGPgE6rddwF9NZmmd0qJm/ZIfgkHIOONWkim
         O9+7OOTeWnqR0BW8k20V4VKN6wtWlTpJZIYBfcuc9jdEAmdcRHGRuB/vlZb5Zh0Apu83
         F0uCTk/XC2vZkTRzc6k40NDSspVBynu/bb0Rg=
MIME-Version: 1.0
In-Reply-To: <20091203071244.GI9121@core.coreip.homeip.net>
References: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com>
	 <20091202230746.611f7fc5@infradead.org>
	 <20091203071244.GI9121@core.coreip.homeip.net>
Date: Thu, 3 Dec 2009 16:15:49 +0800
Message-ID: <563a732e0912030015u7dc1cac2x2a2ae226c7107b4e@mail.gmail.com>
Subject: Re: Should we use preempt_disable() in sleep_on_common()?
From: liu pf <kernelfans@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 3:12 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Dec 02, 2009 at 11:07:46PM -0800, Arjan van de Ven wrote:
>> On Thu, 3 Dec 2009 14:49:14 +0800
>> liu pf <kernelfans@gmail.com> wrote:
>>
>> > Hi:
>> >
>> > I am puzzled with the following scenario. Could anyone enlighten me?
>>
>>
>> sleep_on family of APIs is very racy and just cannot be used correctly;
>> I'm not surprised that there's a preempt race in it, but trust me, it's
>> not the biggest race... never ever use these APIs!!!
>>
>>
>
> BTW, why do we still have them? I checked couple and they don't seem to
> be used...
>
> --
> Dmitry
>

Hi, what is the substitution for  sleep_on family of APIs? Any sample code?

Thanks
