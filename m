Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbXLSA5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbXLSA5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbXLSA5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:57:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbXLSA5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:57:01 -0500
Message-ID: <47686C09.1070602@redhat.com>
Date: Tue, 18 Dec 2007 19:55:37 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
References: <fa.WmGIH8th8MfmciABVSBi6whxeFE@ifi.uio.no> <fa.Obg5E3fyax+MaF94//uo40q/Zyk@ifi.uio.no> <fa./6K5nXEIpws4VU8HtJhQjF4AoGg@ifi.uio.no> <fa.V82IIxMkW3eu+9B44NfoyYYQDP4@ifi.uio.no> <fa.DM9AyNQQtam66XpKVeXeqS639os@ifi.uio.no> <fa.f5O3U527Rv8DNk05hDFRjdCaeFE@ifi.uio.no> <47686197.6080807@shaw.ca>
In-Reply-To: <47686197.6080807@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2007 07:11 PM, Robert Hancock wrote:
>> However, I wonder about that
>>
>>     e0000000-efffffff : pnp 00:0b
>>
>> thing. I actually suspect that that whole allocation is literally
>> *meant* for that 256MB graphics aperture, but the kernel explicitly
>> avoids it because it's listed in the PnP tables.
> 
> That is probably the MMCONFIG aperture, in that case any attempt to map
> the graphics BAR there will have disastrous results. (This BIOS has an
> MCFG table, though it looks like this Fedora kernel has MMCONFIG
> disabled, so we can't tell what it actually contains.)
> 

You can boot with "pci=mmconf" to enable it.

