Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbYBBNdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbYBBNdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbYBBNcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:32:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:22028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYBBNcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LkcKyO22LdMfaxlvsBucPKd9bMoWadPMVSWDkhxhTKW8Zg9dah6h7XKGqHSfAa4lSOhszZ36/KfZ+4ivto/LRxhcu6U9l0v5jBj794wwDYydTU1JlaNDK3r1ss1gwKYcbaMoetydmxFaa/oI91Ahs5cIg5rims1swd7WzKC7ll4=
Message-ID: <47A470F9.9060708@gmail.com>
Date: Sat, 02 Feb 2008 14:32:41 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] Split list.h and move rcu-protected lists into rculist.h
References: <478FBEA0.9090203@gmail.com>	<478FBEEA.6040000@gmail.com> <20080201155826.a2d308c1.akpm@linux-foundation.org>
In-Reply-To: <20080201155826.a2d308c1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 17 Jan 2008 21:47:38 +0100
> Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
> 
>> This patch moves rcu-protected lists from list.h into a new header
>> file rculist.h.
> 
> I'm getting way too many compilation errors from this, perhaps because of
> new rcu-list usages which weren't present in the old tree (ie: current
> Linus mainline) which you tested it against.
> 

Not really suprising, sorry for the mess.

> The most practical way to prepare a patch like this is to either make it
> back-compatible (for a while at least) or to prepare and carefully test it
> against latest -mm.  That way you'll pick up everyone's new code.
> 

I'll try to come up with something better: if rculist helpers are used from
list.h then issue a warning otherwise every thing is fine since the helpers
are imported from rculist.h.

Do you think it's better ?

In the meanwhile, could you drop the patches related to rculist from mm
tree ?

Thanks
		Franck
