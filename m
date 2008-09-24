Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYIXTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYIXTeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIXTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:34:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:17188 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYIXTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=puTg6jJRta78ZzQK8rUCI09lDHEDF7dyoRajjP88AgTO6++c9ncWO/creykPG/HltM
         RtZ/qnc7d2SMBg6Z82xGvlrWrAdOPmG2hLMo128DtS5uVfKnZnX2FMUlFkg2uaHZHcAl
         xDi9W7gDmphyG5nl0G/KBa7DphFVotmO/hvF4=
Date: Wed, 24 Sep 2008 23:36:17 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080924193617.GA13888@x200.localdomain>
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 05:07:59PM +0200, Paweł Sikora wrote:
> with out-of-tree kernel modules we (users and linux distributions)
> have a problem - with every frequent kernel release we need
> to rebuild them all due to vermagic and possible abi changes.
> this leads to lot of useless work (bumping rpm specs releases,
> preparing rpm packages and so on).

That's your price for using out-of-tree junk.

> naturally we could workaround the modprobe vermagic errors
> but we currently can't detect the big-bang kernel abi changes.

And never will be able to.

> e.g., some kernel function changes its parameter list while
> the exported function(symbol) name still staying unchanged.
> finally we get a modprobe-big-bang.

*bang*

> in fact, we can't use a c++ symbol name mangling to avoid
> such problems but kernel build system could use a linker script
> to versioning symbols (like glibc/libgcc). during the abi change,
> kernel developers could just bump the symbol version and
> external modules could be refused during loading with
> 'unresolved symbol' error which is imho much better solution
> that an oops.

So kernel developers should waste time thinking if some change will
result in some innumerable junk being broken, resulting in symbol
version bump?

> is it acceptable and possible to introducing such solution?

No. Don't even bother.
