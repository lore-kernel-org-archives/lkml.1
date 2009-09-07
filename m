Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZIGJWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZIGJWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZIGJWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:22:47 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36973 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZIGJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QXE81eYgHdg8eFMHwguuIbJw5ewLJ3bBEco9SHEv1DAvVE+yfc0V2nS5qZn3cn7T58
         YMZ1UXGqYaIHAWN3uI2hGX3yOckQFcOm76sh083TLXlRbTqIpHmsH/8vR/piMGULiUHP
         YMU4D3U7sztuKFGkiqjWWt3QQPVq4GaEPmfHk=
MIME-Version: 1.0
In-Reply-To: <20090907090441.GB4717@osiris.boeblingen.de.ibm.com>
References: <20090907153723.0c984c83.sfr@canb.auug.org.au>
	 <84144f020909062310u37ecdddfw31c6cc9a22ccabd9@mail.gmail.com>
	 <20090907173108.3c0148d7.sfr@canb.auug.org.au>
	 <1252309426.4964.3.camel@penberg-laptop>
	 <20090907090441.GB4717@osiris.boeblingen.de.ibm.com>
Date: Mon, 7 Sep 2009 12:22:47 +0300
X-Google-Sender-Auth: 661b80ef727bf04b
Message-ID: <84144f020909070222u51fba710q6121f41a946998c6@mail.gmail.com>
Subject: Re: linux-next: slab tree build failure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Catalin Marinas <catalin.marinas@arm.com>, npiggin@suse.de,
       "Sachin P. Sant" <sachinp@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Mon, Sep 07, 2009 at 10:43:46AM +0300, Pekka Enberg wrote:
>> Aah, let me guess, CONFIG_SLQB? I guess I'll just rebase the damn tree
>> and make it non-default. We need that anyway if we want to merge it to
>> 2.6.32. I'll take a stab at it later this evening (my time zone).

On Mon, Sep 7, 2009 at 12:04 PM, Heiko
Carstens<heiko.carstens@de.ibm.com> wrote:
> Will SLQB be merged during the next merge window? Just realized that s390
> doesn't boot with CONFIG_SLQB (crashes before the console is active).
>
> I tend to ignore bugs which seem to be related to SLQB in linux-next,
> but if it gets merged I might need to look deeper into this.

Yes, that's the plan. That said, there's a long-standing PPC boot-time
bug in SLQB that's still unfixed which could affect other archs as
well AFAICT. Help in tracking that down would be appreciated as Nick
seems to be busy atm.

I am not completely happy with sending something that's known to be
broken to Linus. However, the problem is not getting fixed in slab.git
and everyone seems to be in favor of merging the allocator and mark it
as "experimental" so I'll probably just send it Linus' way for 2.6.32
and let him decide whether to take it or not.

                        Pekka
