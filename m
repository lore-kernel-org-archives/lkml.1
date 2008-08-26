Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbYHZQzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbYHZQzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYHZQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:55:21 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16625 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758925AbYHZQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:55:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 0/5] use lspci style for [%04x:%04x] vendor/device
Date: Tue, 26 Aug 2008 10:55:11 -0600
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
References: <20080825220137.19210.41857.stgit@tigger.helgaas> <20080825150525.6f1b5706@infradead.org> <20080825235313.GA10540@x200.localdomain>
In-Reply-To: <20080825235313.GA10540@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261055.11614.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 August 2008 05:53:13 pm Alexey Dobriyan wrote:
> On Mon, Aug 25, 2008 at 03:05:25PM -0700, Arjan van de Ven wrote:
> > On Mon, 25 Aug 2008 16:01:38 -0600
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > 
> > > These patches change various debug messages to use "[%04x:%04x]" for
> > > PCI vendor/device IDs to follow the format used by lspci(8).
> > 
> > I hope you're adding a new whicked special format specifier for this
> > ... taking a PCI dev struct as argument.
> > 
> > That's be really nice to have;-)
> 
> You should sign Treaty of the Non-Proliferation of Format Specifiers.
> 
> Untill too late...

OK.  I'll wait with any new format specifiers for now.  Relative to
something like printing resources, where a new format specifier could
help get rid of a ton of ugly casts, this PCI vendor/device stuff
is pretty minor.

Bjorn

