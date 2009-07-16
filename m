Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbZGPOgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbZGPOgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbZGPOgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:36:19 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:37110 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbZGPOgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N3YUTz3p/KVRBG0Mwk5UmZn+1rl7EghRSnLgWogObfBSM65E8hkNy3VpwIpSWAB0UZ
         kQimQglRvJcQpznJTYC6OgeYM8k0ttv/rcZErKFdsf/VeYGgY4jnEfq6gB6HKlhqG2Do
         0WuborETvbTDmmxanU6t+ZaO1PO/DjjYR7V2Q=
MIME-Version: 1.0
In-Reply-To: <4A5F2EEC.8010508@linux.intel.com>
References: <1247643512.26272.74.camel@rzhang-dt>
	 <87ocrm6xeq.fsf@basil.nowhere.org>
	 <1247710483.26272.170.camel@rzhang-dt>
	 <20090716114020.GA11928@khazad-dum.debian.net>
	 <4A5F2EEC.8010508@linux.intel.com>
Date: Thu, 16 Jul 2009 16:36:17 +0200
Message-ID: <b637ec0b0907160736r3477301fn25c495b03a18dc4a@mail.gmail.com>
Subject: Re: [PATCH 0/8] device async action mechanism
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 3:45 PM, Arjan van de Ven<arjan@linux.intel.com> wrote:
> Henrique de Moraes Holschuh wrote:
>>
>> On Thu, 16 Jul 2009, Zhang Rui wrote:
>>>
>>> the kernel device suspend time is reduced from 3.2s to 2.8s after
>>> applying this patch set in my test box.
>>
>> It will give even a bigger boot time saving on ThinkPads, where there is a
>> Synaptics (or ALPS if you are unlucky) touchpad with the trackpoint behind
>> it... it takes about 2s to init both devices here.  That's two seconds of
>> boot time you can shove off if it is being initialized assyncronously :-)
>>
>
> that's a different problem that I don't think this will solve; as long
> as you keep the boot of the kernel wait for all async actions, you're going
> to hit that wait. In Moblin we have a (bad) patch to not do the wait,
> at some point we need to figure how to get a mainline-able patch....
> --

Is it possible for you to post that patch (or point to a website hosting it)?



> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
