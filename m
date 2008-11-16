Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYKPLQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYKPLQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 06:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYKPLQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 06:16:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44926 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751736AbYKPLQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 06:16:41 -0500
Date: Sun, 16 Nov 2008 11:14:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Philipp Kohlbecher <xt28@gmx.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: alternative identifier for Phoenix BIOS
Message-ID: <20081116111447.23fbfe7e@lxorguk.ukuu.org.uk>
In-Reply-To: <491F7D88.7080403@zytor.com>
References: <491EEDE8.5080508@gmx.de>
	<491F7D88.7080403@zytor.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008 17:55:20 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Philipp Kohlbecher wrote:
> > My laptop (a Samsung X20) contains a Phoenix BIOS and would benefit from
> > patch 1e22436eba84edfec9c25e5a25d09062c4f91ca9 (x86: reserve low 64K on
> > AMI and Phoenix BIOS boxen).
> > 
> > However, according to /sys/class/dmi/id/bios_vendor, the BIOS identifies
> > its vendor as "Phoenix Technologies LTD" (sans the comma).
> 
> Given that AMI and Phoenix combined is something like 80% of the BIOS
> market, if not more, it might simply be easier to make it unconditional,
>  or make it a whitelist instead.

Far more useful would be to make people aware of the problem. If the BIOS
is scribbling in the low 64K of RAM not just BIOS areas, and doing so
outside of ACPI marked areas they need to fix the BIOS ASAP. If they leave
their BIOSes randomly scribbling in operating system memory areas then as
with previous (hardware related) cases of vendors knowingly shipping
corrupting equipment they'll be building up a huge class action legal
liability.

As such making sure the vendor knows in a way they cannot deny is a very
useful activity.

Alan
