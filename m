Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZFEN6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZFEN6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZFEN6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:58:24 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57019 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbZFEN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ceECYQpV3KuYQgyBe+pUu3dDNBDVyOm0g/n1xCNs2sGApoynWAoj+jFNK4ll0S8mun
         mNgM7WTYFN7ouEkx0vM51hBxE+Fr9gSOJudKeM+q2OKof5fqeE2stfyUMbmOyC8Z2MGf
         4Ts28utZqL9PdSy0CKa49Uzdn2B8/LbH0S3Vk=
MIME-Version: 1.0
In-Reply-To: <1244209873.23533.29.camel@penberg-laptop>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <1244205844.23533.21.camel@penberg-laptop>
	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
	 <1244209873.23533.29.camel@penberg-laptop>
Date: Fri, 5 Jun 2009 15:58:23 +0200
Message-ID: <71cd59b00906050658k28a5b915h156f64221fe13186@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Corentin Chary <corentin.chary@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 3:51 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
> Hi Corentin,
>
> On Fri, 2009-06-05 at 15:02 +0200, Corentin Chary wrote:
>> > That said, I am more than happy to measure this but I need a little bit
>> > more information to get started as I have never used powertop. So what
>> > is it exactly you want me to do?
>>
>> PowerTop (with a corretly configured kernel) will give you a power
>> usage estimate.
>>
>> CONFIG_NO_HZ=y
>> CONFIG_TIMER_STATS=y
>> CONFIG_DEBUG_KERNEL=y
>>
>> For propers results, shutdown all services and just keep a shell
>> (without X or network).
>> You can also test that with and without the camera driver.
>
> I did not see a power usage estimate. I am running PowerTOP 1.11 that
> comes with Ubuntu 9.04. So I am not sure if what I did is what you
> wanted me to do but I ran "powertop -t 60 -d" with camera enabled and
> disabled and here are the results.

Thanks for the results, next week I'll do some test on a minimal setup.


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
