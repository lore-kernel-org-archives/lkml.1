Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXK3XwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXK3XwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXK3Xv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:51:56 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:50643 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755285AbXK3Xvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:51:54 -0500
Message-ID: <4750A225.3060505@crispincowan.com>
Date: Fri, 30 Nov 2007 15:52:05 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: Out of tree module using LSM
References: <47507818.8010808@crispincowan.com> <Xine.LNX.4.64.0712010824170.5027@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0712010824170.5027@us.intercode.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Fri, 30 Nov 2007, Crispin Cowan wrote:
>> restored faces a lot of challenges, but I hope that some kind of
>> solution can be found, because the alternative is to effectively force
>> vendors like Sophos to do it the "dirty" way by fishing in memory for
>> the syscall table.
>>     
> I don't think this is quite correct.
>
> The alternative is to engage with the kernel community to become part of 
> the development process, to ensure that appropriate APIs are implemented, 
> and to get code upstream before shipping it.
>   
That would be part of the "some kind of solution can be found" so I
think we are in agreement here.

> In any case, a patch to revert the dynamic aspect of LSM has been posted 
> by Arjan (and acked by myself) for the case of valid out of tree users.  
> The only case of this so far has been Multiadm, although there seems to be 
> no reason for it to stay out of tree.
>   
Dazuko. It has the same yucky code issues as Talpa, but AFAIK is pure
GPL2 and thus is clean on the license issues.

That these modules are valid modules that users want to use, are GPL
clean, and are *not* something LKML wants to upstream because of code
issues, is precisely why the LSM interface makes sense.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

