Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbYC0VAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbYC0VAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbYC0VAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:00:39 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48182 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759559AbYC0VAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:00:37 -0400
Date: Thu, 27 Mar 2008 17:00:36 -0400
To: David Brownell <david-b@pacbell.net>
Cc: mgross@linux.intel.com, Greg KH <greg@kroah.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Real time USB2Serial devices and behaivor
Message-ID: <20080327210036.GA20027@csclub.uwaterloo.ca>
References: <20080326152559.GA17164@linux.intel.com> <20080326162728.GC6020@kroah.com> <20080326164946.GA17928@linux.intel.com> <200803271248.40519.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803271248.40519.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 12:48:40PM -0700, David Brownell wrote:
> I happened across this the other day, and saved the URL since
> the price was relatively sane ... $15 vs the $60 I saw at
> another site, although ISTR Fry's used to have them at $5:
> 
>   http://www.wrighthobbies.net/catalog/index.php?cPath=47
> 
> Yeah, I know.  "It's getting very hard to find real PCI slots
> any more."  :(

Well digi (www.digi.com) makes some nice PCI serial cards, that work
with the jsm driver.  Not sure how many models are supported, but
certainly I have used the 2 port card with DE-9 connectors.

A little bit of patching will make the jsm driver run any exar
17[CD]15[248] based card, like the ones we use on the routers I work on.
The digi cards use a rebranded exar chip with a different PCI id.  Much
better than using the 8250 driver to run the exar's in PCI 16550A mode,
although it does work.

They have PCIe cards too although I have no idea if they use the same
interface or not (it would make sense to do so on the part of exar
though).

> It seems like some companies (notably *cough* Intel) are
> on a little jihad to get rid of serial ports...
> 
> I'd think that in a controlled environment (fixed set of
> USB connections) USB should be able to meet fairly chosen
> "real time" latency ceilings.  The stack probably needs a
> few semantic updates to make it happen -- e.g. URB completions
> are issued in_irq() -- but it shouldn't be insurmountable.

-- 
Len Sorensen
