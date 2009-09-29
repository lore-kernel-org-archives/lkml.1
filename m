Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZI2RE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZI2RE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZI2RE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:04:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56603 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbZI2RE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:04:58 -0400
Date: Tue, 29 Sep 2009 18:05:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Lennart Baruschka" <FunFlyer@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
Message-ID: <20090929180555.3c4a7259@lxorguk.ukuu.org.uk>
In-Reply-To: <m3bpku3peg.fsf@intrepid.localdomain>
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
	<20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
	<20090929075416.77960@gmx.net>
	<20090929101114.1712314b@infradead.org>
	<m3bpku3peg.fsf@intrepid.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 14:29:27 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > a single PIO instruction will NOT be interrupted by an interrupt.
> > And can easily take several microseconds (remember: 8Mhz bus
> > emulation)
> 
> Not that long, there is no emulation there (except for port #80 (hex?)
> and similar). Normal 33 MHz access.

ATA accesses go across the cable and while some of them are snooped,
cached and other magic is done there are cases it turns into a
transaction back and forth with the drive - that *is* slow. PIO 0 in fact
is ISA speed
