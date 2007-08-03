Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbXHCEsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbXHCEsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 00:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXHCEsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 00:48:31 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45734
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXHCEsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 00:48:30 -0400
Date: Thu, 2 Aug 2007 21:45:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ondrej Zajicek <santiago@crfreenet.org>
cc: Jan Engelhardt <jengelh@computergmbh.de>, Michael Tokarev <mjt@tls.msk.ru>,
       Herbert Rosmanith <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev
 numbering]
In-Reply-To: <20070802145152.GB19346@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708022144020.6905@asgard.lang.hm>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
 <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
 <20070802145152.GB19346@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Ondrej Zajicek wrote:

> 
> On Thu, Aug 02, 2007 at 01:47:23PM +0200, Jan Engelhardt wrote:
>> It does not rename ethX to the "next free" one, but to a _persistent_ one.
>> If it were a "next free" thing, then removing a card would shuffle all
>> your eth around again (and invalidate your iptables rules at the same
>> time, to note).
>
> It is questionable what is _persistent_ . MAC-based names are persistent
> with regard to adding and removing of other cards, 'Plain' names are persistent
> with regard to replacing that card with different item (of a same kind).
>
> I am very happy that (using 'plain' names) i can send technician to
> replace broken NIC in our routers without need for configuration
> change.

this is a very important point, and with the distros (and many kernel 
people) treating udev as a requirement this is going to bite a lot of 
people.

David Lang
