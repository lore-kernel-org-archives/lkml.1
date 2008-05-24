Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbYEXBwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbYEXBwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYEXBv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:51:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:7144 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYEXBv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=agb13vXUDCmDr2YB1SaiNwZkn35b6gGC3pjaybL+3ltnE/rKXvKQWQ2uFmqBYcX97nuO7WRkHbN9AUUn6kmbW/ddsUxKi+Kj4Ko2une4f6k/l+u5ljQUw9rDyK1XZy1OB5oDx+JQEbaLSmnbAYL3mWv9mm0Af3GFlmoWT8SlB60=
Message-ID: <86802c440805231851t12a83e54w78d2c120ed3d6b20@mail.gmail.com>
Date: Fri, 23 May 2008 18:51:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080524020950.1538624a@snowcone>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518014111.4f32298b@googlemail.com>
	 <20080520014405.5eb150cd@googlemail.com>
	 <86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	 <20080520022446.3b9c335a@googlemail.com>
	 <86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
	 <20080520041655.0552236d@googlemail.com>
	 <86802c440805192022n29e191dfped3ee5afa7894288@mail.gmail.com>
	 <20080524005021.67b98674@snowcone>
	 <86802c440805231705g534e9245oc359dc316ae5b1cd@mail.gmail.com>
	 <20080524020950.1538624a@snowcone>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 6:09 PM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> On Fri, 23 May 2008 17:05:34 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> > Without the ram_reserve
>> > patch, /proc/iomem is as it was earlier in the discussion.
>> >
>> >> can you boot with pnpacpi=off ?
>> >
>> > No, that doesn't help either.
>>
>> how about /proc/iomem with pnpacpi=off?
>
> I've attached /proc/iomem from current head minus the original patch,
> with and without pnpacpi=off.

it's weird,

you should have

00000 - 9f400: System RAM  ===> is not showing up
100000 - d7ff0000: System RAM ===> is not showing up
100000000-11fffffff : System RAM

YH
