Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbXLRXSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbXLRXSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXLRXRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:17:53 -0500
Received: from are.twiddle.net ([64.81.246.98]:54402 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbXLRXRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:17:52 -0500
Date: Tue, 18 Dec 2007 14:17:23 -0800
From: Richard Henderson <rth@twiddle.net>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071218221723.GA25130@twiddle.net>
Mail-Followup-To: Chuck Ebbert <cebbert@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
	Keith Packard <keithp@keithp.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net> <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org> <47683FA1.6070103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47683FA1.6070103@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 04:46:09PM -0500, Chuck Ebbert wrote:
> pnpacpi=off should work.

This does result in the graphics bar being placed at e0000000,
and does result in a system lockup when X starts.  So it appears
as if there's really something there.


r~
