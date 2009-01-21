Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZAUVsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZAUVsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZAUVsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:48:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49078 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbZAUVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:48:30 -0500
Date: Wed, 21 Jan 2009 21:47:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
Message-ID: <20090121214746.2b15d1de@lxorguk.ukuu.org.uk>
In-Reply-To: <18807.33113.550070.329912@harpo.it.uu.se>
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
	<18807.33113.550070.329912@harpo.it.uu.se>
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

On Wed, 21 Jan 2009 21:11:05 +0100
Mikael Pettersson <mikpe@it.uu.se> wrote:

> Hugh Dickins writes:
>  > I've a Dell Precision 670 here (four-year-old EM64T Xeon with ata_piix)
>  > which doesn't like your commit 871af1210f13966ab911ed2166e4ab2ce775b99d
>  > libata: Add 32bit PIO support.  Full dmesg (and .config) attached, but
>  > here's an extract showing the start of the error messages on ata2:

Cool - so we need two different 32bit PIO methods - at least according to
the docs for the AMD we should use entirely 32bit I/O there. Fun fun


Alan
