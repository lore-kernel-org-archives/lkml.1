Return-Path: <linux-kernel-owner+w=401wt.eu-S1764244AbXETGyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764244AbXETGyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763858AbXETGy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:54:27 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:37333 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759474AbXETGy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:54:26 -0400
Message-ID: <464FF099.1000107@simon.arlott.org.uk>
Date: Sun, 20 May 2007 07:54:17 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michal@logix.cz, ioe-lkml@rameria.de
Subject: Re: [PATCH (v2)] crypto: Remove pointless padlock module
References: <4633DB56.6070000@simon.arlott.org.uk> <4633FBFF.7050202@oracle.com> <463450C6.5060103@simon.arlott.org.uk> <20070518064500.GA16394@gondor.apana.org.au> <464F4FD1.5030308@simon.arlott.org.uk> <20070520031550.GA22903@gondor.apana.org.au>
In-Reply-To: <20070520031550.GA22903@gondor.apana.org.au>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/07 04:15, Herbert Xu wrote:
> On Sat, May 19, 2007 at 08:28:17PM +0100, Simon Arlott wrote:
>> It should be a bool that doesn't select anything, the AES and SHA modules 
>> will select CRYPTO_ALGAPI. It could also depend on MVIAC3_2 || MVIA_C7 
>> instead of X86_32.
> 
> Having it as a tristate means that we don't have to duplicate the
> dependencies and selects that each padlock algorithm would otherwise
> do.  So is there actually a problem with it being a tristate?

It has nothing to compile as a module, so M makes no sense. Each algorithm 
already selects CRYPTO_ALGAPI indirectly.

-- 
Simon Arlott
