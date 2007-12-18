Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbXLRVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbXLRVqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750700AbXLRVqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:46:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXLRVqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:46:42 -0500
Message-ID: <47683FA1.6070103@redhat.com>
Date: Tue, 18 Dec 2007 16:46:09 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Richard Henderson <rth@twiddle.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net> <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2007 04:09 PM, Linus Torvalds wrote:
> 
> I wonder what the heck is the point of that pnp entry. Just for fun, can 
> you try to just disable CONFIG_PNP, and see if it all works then?
> 

pnpacpi=off should work.

PnP is also trying (and failing) to reserve all physical memory.
