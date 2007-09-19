Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXISMUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXISMUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbXISMUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:20:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbXISMUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:20:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: PCI Interrupt
Date: Wed, 19 Sep 2007 14:32:12 +0200
User-Agent: KMail/1.9.5
Cc: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>,
       Duncan.Perrett@elekta.com, Linux kernel <linux-kernel@vger.kernel.org>
References: <20070919101430.GA3226@ff.dom.local>
In-Reply-To: <20070919101430.GA3226@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191432.12831.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 September 2007 12:14, Jarek Poplawski wrote:
> On 18-09-2007 16:42, Rafael J. Wysocki wrote:
> ...
> > 
> > Hm, edge-triggered interrupts cannot be shared, AFAIK.
> > 
> 
> Let's agree it's only a superstition...
> 
> http://en.wikipedia.org/wiki/Edge_triggered_interrupt

Well, if this is an MSI (which is edge-triggered), for example, it cannot be
shared.

Also, you must use a level-triggered interrupt for SCI, because that has to be
shareable.

Greetings,
Rafael
