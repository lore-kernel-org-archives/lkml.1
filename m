Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbXLTVXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbXLTVXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbXLTVW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:22:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:58114 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbXLTVWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:22:55 -0500
Subject: Re: PCI resource problems caused by improper address rounding
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
In-Reply-To: <20071220084616.GA28578@jurassic.park.msu.ru>
References: <47671377.6000405@redhat.com>
	 <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
	 <47680489.6040809@redhat.com>
	 <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
	 <20071218202234.GA24525@twiddle.net>
	 <20071219002349.A12278@jurassic.park.msu.ru>
	 <alpine.LFD.0.9999.0712181338150.21557@woody.linux-foundation.org>
	 <20071220084616.GA28578@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 08:21:39 +1100
Message-Id: <1198185699.6779.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another turd is pci_scan_device() which can't cope with 64 bits BARs on
32 bits platforms even when they have 64 bits resources. I'll send a fix
for that.

Ben.


