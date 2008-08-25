Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYHYU7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYHYU7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYHYU7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:59:44 -0400
Received: from gw.goop.org ([64.81.55.164]:38122 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYHYU7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:59:43 -0400
Message-ID: <48B31D3D.1080701@goop.org>
Date: Mon, 25 Aug 2008 13:59:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Sally-Anne Edwards <sallyanne.edwards@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: domU lenny not working: BUG: unable to handle kernel	paging
 request at e7437cc0
References: <39fd98ca0808240801x7edbe0e6gf242f08de88cd92c@mail.gmail.com>	 <39fd98ca0808240804p454faff9u289abfc074dbea3@mail.gmail.com>	 <48B3099E.3060407@goop.org>	 <1219693601.27921.172.camel@localhost.localdomain> <1219695753.27921.175.camel@localhost.localdomain>
In-Reply-To: <1219695753.27921.175.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Mon, 2008-08-25 at 20:46 +0100, Ian Campbell wrote:
>   
>> I thought the tools did this (so expected the Lenny tools to be
>> correct) but looking at the code it seems it is the domain 0 kernel
>> which does it.
>>     
>
> Uh, I'm thinking backwards here. It's the frontend which writes it but
> the backend needs to understand it which the Etch kernel does not.
>
> Unfortunately this means that writing the protocol node as I suggest
> won't work.
>
> Only thing I can recommend at the moment is to use a kernel which does
> have this (i.e. one from
> http://xenbits.xensource.com/linux-2.6.18-xen.hg) or to use a 32 bit
> Etch kernel if you want to run 32 bit guests.

Or run a 64-bit domU kernel?  Should work fine with a 32-bit userspace.

    J

