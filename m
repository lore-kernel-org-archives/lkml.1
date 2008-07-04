Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbYGDO5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbYGDO5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758992AbYGDO5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:57:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39888 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758483AbYGDO5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:57:22 -0400
Date: Fri, 4 Jul 2008 15:38:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704153822.4db2f325@lxorguk.ukuu.org.uk>
In-Reply-To: <486E2E9B.20200@garzik.org>
References: <1215093175.10393.567.camel@pmac.infradead.org>
	<20080703173040.GB30506@mit.edu>
	<1215111362.10393.651.camel@pmac.infradead.org>
	<20080703.162120.206258339.davem@davemloft.net>
	<486D6DDB.4010205@infradead.org>
	<87ej6armez.fsf@basil.nowhere.org>
	<1215177044.10393.743.camel@pmac.infradead.org>
	<486E2260.5050503@garzik.org>
	<1215178035.10393.763.camel@pmac.infradead.org>
	<486E2818.1060003@garzik.org>
	<1215179161.10393.773.camel@pmac.infradead.org>
	<486E2E9B.20200@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2008 10:07:23 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> David Woodhouse wrote:
> > On Fri, 2008-07-04 at 09:39 -0400, Jeff Garzik wrote:
> >> You have been told repeatedly that cp(1) and scp(1) are commonly used
> >> to transport the module David and I care about -- tg3.  It's been a
> >> single file module since birth, and people take advantage of that
> >> fact.
> > 
> > And you can _continue_ to do that. You'd need to install the firmware
> > just once, and that's all. It's a non-issue, and it isn't _worth_ the
> > added complexity of building the firmware into the module.
> 
> We can stop there.  Real-world examples are apparently non-issues not 
> worth your time.

Jeff - real world issues and gains are measured on a scale across the
userbase not "Jeff's having a tantrum because his specific usage case
requires one extra copy once"

And we had the same argument over ten years ago about those evil module
things which stopped you just using scp to copy the kernel in one go.
Fortunately the nay sayers lost so we have modules.

Alan
