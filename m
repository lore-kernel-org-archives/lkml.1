Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYEXAFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYEXAFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYEXAFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:05:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:60055 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYEXAFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XkqOQ5yx4LngoNLNC8UslRQnBpp8sJGAezFojoaRdBMjgrJngvqeENxYxBXEBcl9zQmCaMmUJLitIbJsuF3DzZJN0ss4n+IvbIqPLrR5oNo4XS1IoOLTuYfcPS0SnTZBpPiv9Q7OGTqyoUeDiaoFneq65Xt51wRr4sps5uSr5e0=
Message-ID: <86802c440805231705g534e9245oc359dc316ae5b1cd@mail.gmail.com>
Date: Fri, 23 May 2008 17:05:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080524005021.67b98674@snowcone>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518014111.4f32298b@googlemail.com>
	 <20080518232347.7964835c@snowcone>
	 <86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	 <20080520014405.5eb150cd@googlemail.com>
	 <86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	 <20080520022446.3b9c335a@googlemail.com>
	 <86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
	 <20080520041655.0552236d@googlemail.com>
	 <86802c440805192022n29e191dfped3ee5afa7894288@mail.gmail.com>
	 <20080524005021.67b98674@snowcone>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 4:50 PM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> (Apologies for the delay. I've not had physical access to the box for a
> few days.)
>
> On Mon, 19 May 2008 20:22:45 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> >> seems acpi pnp resource cause some problem....
>> >>
>> >> please try attached patch and send out /proc/mtrr
>> >
>> > The patch doesn't help I'm afraid.
>>
>> sorry, please send /proc/iomem
>
> Sorry, I'm getting confused here. I can't send /proc/iomem with the
> ram_reserve patch applied since the system won't boot (and it appears
> to collide with the original commit, so I can't revert that and apply
> the patch to get a booting system).

You don't need that patch...

> Without the ram_reserve
> patch, /proc/iomem is as it was earlier in the discussion.
>
>> can you boot with pnpacpi=off ?
>
> No, that doesn't help either.
how about /proc/iomem with pnpacpi=off?

YH
