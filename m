Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbXISMs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbXISMs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXISMsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:48:21 -0400
Received: from mx10.go2.pl ([193.17.41.74]:41246 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754766AbXISMsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:48:20 -0400
Date: Wed, 19 Sep 2007 14:50:23 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>,
       Duncan.Perrett@elekta.com, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCI Interrupt
Message-ID: <20070919125023.GC3226@ff.dom.local>
References: <20070919101430.GA3226@ff.dom.local> <200709191432.12831.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709191432.12831.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 02:32:12PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 19 September 2007 12:14, Jarek Poplawski wrote:
> > On 18-09-2007 16:42, Rafael J. Wysocki wrote:
> > ...
> > > 
> > > Hm, edge-triggered interrupts cannot be shared, AFAIK.
> > > 
> > 
> > Let's agree it's only a superstition...
> > 
> > http://en.wikipedia.org/wiki/Edge_triggered_interrupt
> 
> Well, if this is an MSI (which is edge-triggered), for example, it cannot be
> shared.

I'd rather say: "which is handled like edge-triggered".

> 
> Also, you must use a level-triggered interrupt for SCI, because that has to be
> shareable.

O.K. Let's agree we differ here a bit...

Cheers,
Jarek P.
