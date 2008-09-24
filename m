Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYIXVF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYIXVF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYIXVFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:05:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:36821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbYIXVFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:05:06 -0400
Date: Wed, 24 Sep 2008 14:05:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "=?UTF-8?B?UGF3ZcWC?= Sikora" <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080924140516.3771c413@infradead.org>
In-Reply-To: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 17:07:59 +0200
"Paweł Sikora" <pluto@agmk.net> wrote:

> Hi All,
> 
> with out-of-tree kernel modules we (users and linux distributions)
> have a problem - with every frequent kernel release we need
> to rebuild them all due to vermagic and possible abi changes.
> this leads to lot of useless work (bumping rpm specs releases,
> preparing rpm packages and so on).
> 
> naturally we could workaround the modprobe vermagic errors
> but we currently can't detect the big-bang kernel abi changes.
> e.g., some kernel function changes its parameter list while
> the exported function(symbol) name still staying unchanged.
> finally we get a modprobe-big-bang.
> 
> in fact, we can't use a c++ symbol name mangling to avoid
> such problems but kernel build system could use a linker script
> to versioning symbols (like glibc/libgcc). during the abi change,
> kernel developers could just bump the symbol version and
> external modules could be refused during loading with
> 'unresolved symbol' error which is imho much better solutio


if it were up to me we would remove modversions from the kernel and
just hard require an exact build of the module to the kernel; anything
else is .. at best an educated wild guess.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
