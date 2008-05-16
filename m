Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYEPQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYEPQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYEPQZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:25:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYEPQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:25:15 -0400
Message-ID: <482DB568.1040704@firstfloor.org>
Date: Fri, 16 May 2008 18:25:12 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>,
       tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net
Subject: Re: [PATCH] Re: [PATCH] drivers/net: remove network drivers' last
 few uses of IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <20080515173939.1ec968be@core> <482C7DA3.1090809@garzik.org> <482C953A.4080205@garzik.org> <87abirytxj.fsf@basil.nowhere.org> <20080516105635.6cb1f505@core> <482D5FC5.2070103@firstfloor.org> <20080516121239.GA9627@gondor.apana.org.au>
In-Reply-To: <20080516121239.GA9627@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, May 16, 2008 at 12:19:49PM +0200, Andi Kleen wrote:
>> Just think a little bit: system has no randomness source except the
>> hardware RNG. you do your strange randomness verification. if it fails
>> what do you do? You don't feed anything into your entropy pool and all
>> your  random output is predictable (just boot time)  If you add anything
>> predictable from another source it's still predictable, no difference.
> 
> You can continue to feed data into the pool even if it fails the
> test.  You just keep the entropy value same as before.

You could do that, but what advantage would it have? I don't think it's
worth running the FIPS test, or rather requiring the user land daemon
and leaving behind most of the userbase just for this.

-Andi
