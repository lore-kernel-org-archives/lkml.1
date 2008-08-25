Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbYHYWPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbYHYWPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYHYWP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:15:28 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31976 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYHYWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:15:27 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/5] use lspci style for [%04x:%04x] vendor/device
Date: Mon, 25 Aug 2008 16:15:24 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080825220137.19210.41857.stgit@tigger.helgaas> <20080825150525.6f1b5706@infradead.org>
In-Reply-To: <20080825150525.6f1b5706@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251615.24785.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 August 2008 04:05:25 pm Arjan van de Ven wrote:
> On Mon, 25 Aug 2008 16:01:38 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > These patches change various debug messages to use "[%04x:%04x]" for
> > PCI vendor/device IDs to follow the format used by lspci(8).
> 
> I hope you're adding a new whicked special format specifier for this
> ... taking a PCI dev struct as argument.
> 
> That's be really nice to have;-)

Huh, that's kind of a cool idea.  The %p<x> namespace is unlimited,
right?  If it were only a single character specifier, this one doesn't
seem common enough to eat 1/26 of the space.
