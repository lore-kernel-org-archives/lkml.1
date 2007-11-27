Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbXK0N6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbXK0N6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXK0N6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:58:44 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4274 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271AbXK0N6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:58:43 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: andi@firstfloor.org (Andi Kleen)
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Cc: rusty@rustcorp.com.au, rdreier@cisco.com, ak@suse.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Organization: Core
In-Reply-To: <20071127105016.GC24223@one.firstfloor.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Ix0ws-0001Vh-00@gondolin.me.apana.org.au>
Date: Tue, 27 Nov 2007 21:58:02 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> On Tue, Nov 27, 2007 at 03:26:52PM +1100, Rusty Russell wrote:
>> On Monday 26 November 2007 16:58:08 Roland Dreier wrote:
>> >  > > I agree that we shouldn't make things too hard for out-of-tree
>> >  > > modules, but I disagree with your first statement: there clearly is a
>> >  > > large class of symbols that are used by multiple modules but which are
>> >  > > not generically useful -- they are only useful by a certain small
>> >  > > class of modules.
>> >  >
>> >  > If it is so clear, you should be able to easily provide examples?
>> >
>> > Sure -- Andi's example of symbols required only by TCP congestion
>> > modules;
>> 
>> Exactly.  Why exactly should someone not write a new TCP congestion module?
> 
> Agreed the congestion modules are a corner case. I even mentioned that in the
> patch. I would be happy to drop that one if that is the consensus.
> It was more done as a example anyways. That is why I made it an separate
> namespace from "tcp"
> 
> But for many other TCP symbols it makes a lot of sense: all the functions
> only used by tcp_ipv6.c. If someone wants to write support for a "IPv7" or
> similar they really should do it in tree. So I think the "tcp" and  "inet"
> namespaces make a lot of sense.

OK, short of making IPv4 a module (which would be a worthy task :)
do you have an example where a symbol is used by more than one module
but needs to be put into a namespace?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
