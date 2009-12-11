Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZLKNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZLKNIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZLKNIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:08:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46545 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZLKNIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:08:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K/5YM+mBPo5lFt64KPxzVDSwEXplf344rtiw3nd7oIEd3zbNrKCH6esyba/13/IsA+
         8uGr+pTnx31eF0u7X/vU0uThpBVJ24xP5ruwq51kesH1kjvPM8N6aPaHHkYQcW+A7s3Y
         pIrHTNCrW+EY21AILB1gxgxWR5lXH/sBAAkuc=
MIME-Version: 1.0
In-Reply-To: <4B222426.8000904@gmail.com>
References: <4B192D08.9080608@gmail.com>
	 <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>
	 <4B1E85A9.3030005@gmail.com>
	 <9b2b86520912090517l458bc21cobbb138d460e11f53@mail.gmail.com>
	 <4B211346.2000205@gmail.com>
	 <9b2b86520912100900p5796bc35q702af615d3f27a0c@mail.gmail.com>
	 <4B222426.8000904@gmail.com>
Date: Fri, 11 Dec 2009 13:08:50 +0000
Message-ID: <9b2b86520912110508o67a1d437l2ca489e17aeb9be3@mail.gmail.com>
Subject: Re: PATCH: Toshiba Bluetooth enabler (v3)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/09, Jes Sorensen <jes.sorensen@gmail.com> wrote:
> On 12/10/09 18:00, Alan Jenkins wrote:
>> I did question "depends on RFKILL".  If you manually configure a
>> kernel, you will miss "If you have a modern Toshiba laptop with a
>> Bluetooth and an RFKill switch (such as the Portege R500), say Y."
>> unless you enable RFKILL first.  (Which is unnecessary since the
>> driver will work exactly the same with RFKILL=n).  I wouldn't call it
>> a strong objection, but it would be nice to hear the reason you
>> included this dependency.
>>
>> Everything else looks fine.  Thanks for working on this.
>> Alan
>
> The driver is acting as RFKill functionality, even if it doesn't
> provide it in full. We can pull that depend if you like, however
> I still think it's awkward to offer a driver for a functionality
> the user had previously said no to.

Ok.  You have the advantage of having hardware, so you have a better
idea of what the user experience is going to be like.  I can't find
any more compelling argument for dropping the dependency.  If it's
just me feeling uneasy about this, then don't let me stop you.

Alan
