Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYIRH65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYIRH65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYIRH6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:58:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40699 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYIRH6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:58:48 -0400
Date: Thu, 18 Sep 2008 10:58:45 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #11308] tbench regression on each kernel release	from	2.6.22
 -&gt; 2.6.28
In-Reply-To: <1221722733.5149.6.camel@marge.simson.net>
Message-ID: <Pine.LNX.4.64.0809181050040.1034@wrl-59.cs.helsinki.fi>
References: <1221306287.5213.111.camel@marge.simson.net> 
 <48CD1D25.9080301@linux-foundation.org>  <1221421907.4597.24.camel@marge.simson.net>
  <1221475440.4784.39.camel@marge.simson.net>  <1221568105.5020.17.camel@marge.simson.net>
  <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi> 
 <1221626391.5043.13.camel@marge.simson.net>  <1221627676.5125.3.camel@marge.simson.net>
 <20080917104044.GC18764@elte.hu>  <1221651701.5102.17.camel@marge.simson.net>
 <20080917124943.GA7738@elte.hu>  <1221657111.5511.14.camel@marge.simson.net>
  <Pine.LNX.4.64.0809171629550.1034@wrl-59.cs.helsinki.fi> 
 <1221659858.8818.13.camel@marge.simson.net>  <1221721970.5003.9.camel@marge.simson.net>
 <1221722733.5149.6.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008, Mike Galbraith wrote:

> On Thu, 2008-09-18 at 09:12 +0200, Mike Galbraith wrote:
> 
> > 1e65e841bb5584136ed6047c55cf77532afbbb55 is first bad commit
> > commit 1e65e841bb5584136ed6047c55cf77532afbbb55
> > Author: Mike Galbraith <efault@gmx.de>
> > Date:   Wed Sep 17 14:55:50 2008 +0200
> > 
> >     Revert "Revert "block: export "ro" attribute""
> > 
> >     This reverts commit 2c8803af5c1bf41200167f29349f7f1396683a51.
> 
> BTW, the reason it's revert revert is that I reverse bisected the revert
> tree yesterday, and it emitted the same darn result.  I immediately said
> "yeah right, ya screwed up", and created the revert revert tree to make
> sure I couldn't fumble negation.

:-)

gcc compiling something slightly differently would be a nice theory but 
it sort of breaks down now as this commit touches only one .c file...
In the past when I did some static inline .h -> .c uninline sizing tests
I noticed that some changes happened also in places which should have been 
quite much unrelated. Though all the changes were minor anyway (in the 
places I did look), e.g., routed the conditional paths slightly 
differently and added one xor clear reg.

-- 
 i.
