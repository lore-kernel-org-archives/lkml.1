Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbXDZRaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbXDZRaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXDZRaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:30:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:34875 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbXDZRaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=juqZuoX8GQh31oPuf52LapWvHKwC3eoQyc1di9P4QxoWBgiO9SAGa6996IVPcSoUR0KtY27JgqmhSejc6REdhn3kE5vEBXmSNnbk8XZRD4S8V/WMcaZzQZkLj5jgG/kFz/JxxxoH4neD8yRmjbx+TvxQaTpCOkrkE3pLQA32dtw=
Date: Thu, 26 Apr 2007 19:29:55 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Back to the future.
Message-ID: <20070426172955.GA8538@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177579723.5025.233.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <nigel@nigel.suspend2.net> ha scritto:
> On Thu, 2007-04-26 at 11:17 +0300, Pekka Enberg wrote:
>> On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
>> > * Mulithreaded I/O (might as well use multiple cores to compress the
>> > image, now that we're hotplugging later).
>> 
>> I assume this doesn't affect the kernel at all with uswsusp?
> 
> Well uswsusp would benefit from using multiple threads - if it can - to
> do the work. I saw quite an improvement from implementing it.

It's doable[1], but I'm not sure that the added complexity is worth of it.
I'm suprised that you see a big improvement. I'd expect that the image
write is bottlenecked by the disk performance. On my PC (Core2, locked
at 1.6GHz) lzf can compress 250-280MB/s; even with an older CPU that can
do 1/3 it's still more than the disk can handle.

Luca
[1] We may even use MPI to compress over a Beowulf cluster, it's
userspace ;)
-- 
"Ricorda sempre che sei unico, esattamente come tutti gli altri".
