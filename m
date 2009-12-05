Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZLEOj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZLEOj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZLEOjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:39:55 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57238 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175AbZLEOjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:39:54 -0500
X-Sasl-enc: pvdVvqByWY3CCllIx6v6p6mwCeEHdj5GkRPx7AZQV+QC 1260024000
Date: Sat, 5 Dec 2009 12:39:57 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: convert to seq_file
Message-ID: <20091205143957.GA4901@khazad-dum.debian.net>
References: <20091125071642.GD3459@x200.malnet.ru>
 <20091203172609.GA16463@khazad-dum.debian.net>
 <20091203150001.b017c2f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203150001.b017c2f1.akpm@linux-foundation.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Andrew Morton wrote:
> On Thu, 3 Dec 2009 15:26:09 -0200
> Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > Alexey,  I like your patch, but it pretty much clashes with lots of stuff in
> > my patch queue.
> > 
> > I think the easiest way is for me to take in your patch, place it at the end
> > of the queue, and update it when I get to it.
> > 
> > I won't promise I will be able to merge it for 2.6.33, but I can promise I
> > will do it for 2.6.34.  Depends how fast I can get the higher priority stuff
> > out of the door.
> 
> Your patch queue isn't in linux-next :(

It gets there through acpi-test, usually.  I have not been able to submit my
stack of patch well before the merge window lately, though :-(

> Can we fix that?

Well, getting my queue directly in linux-next would be possible, and I would
feel less bad about publishing more often as I'd not have to waste anyone's
time asking them to drop patches if I find out I need to fix something on a
patch that is not in mainline yet (because linux-next regenerates from
scratch automatically).

Note: there _is_ some shuffle in my queue, plus fixing of earlier patches,
so if I sent stuff to Len more often, I'd also end up pestering him often as
well.  I do all I can to preserve perfect bissectability, allowing at most
for some "defined but not used" warnings. I want as few bugs in the driver
as possible at every point in time.  This does mean I go back and fix
patches if I find out they're subtly incorrect before they are in mainline.

Anyway, if I feed my tree directly to linux-next, it could cause problems
for Len since acpi-test is also in linux-next, and thinkpad-acpi is merged
through the acpi trees.  For that to work out without causing problems for
Len, we'd have to arrange for the stuff I submit to him to not make it to
linux-next.

Len, what do you think?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
