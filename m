Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZFZRmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZFZRmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZFZRmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:42:37 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59681 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZFZRmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ew0RJTSOuZfogOhqJ2avHoGxzMYVzvPH+gcSwo8ZW2j8F/st3+Tv1D4eNSzuqxmSPJ
         XD+G8NzUuZIACd+pF+NRBTKnejssuBMIFc181icddktpJ+snasl84WwqszTXFPJvupm3
         nf7CSh25AU9rjFE2MWU+Y3GBFPYak8r06bWMo=
MIME-Version: 1.0
In-Reply-To: <1246035502.4534.21747.camel@localhost.localdomain>
References: <20090625185942.GA29401@linux-os.sc.intel.com>
	 <20090625123750.734b7f50.akpm@linux-foundation.org>
	 <20090625215541.GB29401@linux-os.sc.intel.com>
	 <Pine.LNX.4.64.0906261036080.21067@melkki.cs.Helsinki.FI>
	 <1246035502.4534.21747.camel@localhost.localdomain>
Date: Fri, 26 Jun 2009 20:42:38 +0300
X-Google-Sender-Auth: 337d157984ac4d91
Message-ID: <84144f020906261042g735938f1n77f1983649a0aac0@mail.gmail.com>
Subject: Re: possible recursive locking detected at kmem_cache_free
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rjw@sisk.pl" <rjw@sisk.pl>, "mingo@elte.hu" <mingo@elte.hu>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 7:58 PM, Pallipadi,
Venkatesh<venkatesh.pallipadi@intel.com> wrote:
> On Fri, 2009-06-26 at 00:37 -0700, Pekka J Enberg wrote:
>> Hi Venki,
>>
>> On Thu, 25 Jun 2009, Pallipadi, Venkatesh wrote:
>> > > > Not sure if this has been reported elsewhere. I started seeing this with git
>> > > > kernel from this morning on a system with RedHat EL5 base installation with
>> > > > ext3 root file system. Attached is the config I am using.
>> > > >
>> > > > Let me know if you need any more details. This seems to be at every boot. I
>> > > > am trying the bisect right now.
>> > > >
>> > >
>> > > Thanks.  Let's cc Pekka.
>> > >
>> >
>> > git bisect result.
>>
>> Thanks! I think I just broke lockdep annotations for slab. Does this patch
>> fix things?
>>
>
> Yes. This patch helps.

OK, thanks for testing, Venki! I'll merge this to slab.git first thing
on Monday.

                           Pekka
