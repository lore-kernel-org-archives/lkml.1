Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbXLSDNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbXLSDNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXLSDNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:13:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425AbXLSDNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:13:45 -0500
Date: Tue, 18 Dec 2007 19:12:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Henderson <rth@twiddle.net>
cc: Chuck Ebbert <cebbert@redhat.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <20071219011210.GA25738@twiddle.net>
Message-ID: <alpine.LFD.0.9999.0712181911120.21557@woody.linux-foundation.org>
References: <fa.WmGIH8th8MfmciABVSBi6whxeFE@ifi.uio.no> <fa.Obg5E3fyax+MaF94//uo40q/Zyk@ifi.uio.no> <fa./6K5nXEIpws4VU8HtJhQjF4AoGg@ifi.uio.no> <fa.V82IIxMkW3eu+9B44NfoyYYQDP4@ifi.uio.no> <fa.DM9AyNQQtam66XpKVeXeqS639os@ifi.uio.no> <fa.f5O3U527Rv8DNk05hDFRjdCaeFE@ifi.uio.no>
 <47686197.6080807@shaw.ca> <47686C09.1070602@redhat.com> <20071219011210.GA25738@twiddle.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Dec 2007, Richard Henderson wrote:
>
> Heh.
> 
> PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
> PCI: Not using MMCONFIG.

Well, that at least confirms that e0000000 is indeed the mmconfig area.

One of these days we'll trust the ACPI resource data enough that we can 
use mmconfig even when it's just reserved in those PnP things, which is 
apparently how BIOS writers are suggested to do it (stupidly enough, but 
whatever)

		Linus
