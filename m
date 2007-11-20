Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbXKTDhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbXKTDhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXKTDhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:37:47 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:21231 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752389AbXKTDhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:37:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=160pi6t/1kVzqOX40lW6UAF80Ix34YQIQ5vjMsUrGI2HpjHEeu7u1ZTXn1oDgE8g4oV7ImdhNiLmdQpJN/95P9JsahofbrpuZpKleowMHonVGzeeprDHIRPUHT5SjFPVGxCyFlmwd6909ZYMZ/yZi7d0l6dH4KQPl1d86zyjKEs=  ;
X-YMail-OSG: 7WWYuPEVM1lxdBWFsqtwQEBmtEKOsF4oSiAYZ5ScqU1jRAWt4oIJfJ5EfSTYTz48RXzyM2Bdhw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Tue, 20 Nov 2007 14:37:37 +1100
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, ak@suse.de, akpm@linux-foundation.org,
       travis@sgi.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <474239CA.20403@zytor.com> <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201437.38045.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 13:02, Christoph Lameter wrote:
> On Mon, 19 Nov 2007, H. Peter Anvin wrote:
> > You're making the assumption here that NUMA = large number of CPUs. This
> > assumption is flat-out wrong.
>
> Well maybe. Usually one gets to NUMA because the hardware gets too big to
> be handleed the UMA way.

Not the way things are going with multicore and multithread, though
(that is, the hardware can be one socket and still have many cpus).

The chip might have several memory controllers on it, but they could
well be connected to the caches with a crossbar, so it needn't be
NUMA at all. Future scalability work shouldn't rely on many cores
~= many nodes, IMO.
