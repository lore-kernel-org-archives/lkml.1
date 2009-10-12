Return-Path: <linux-kernel-owner+w=401wt.eu-S933343AbZJLVwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbZJLVwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbZJLVwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:52:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbZJLVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:52:24 -0400
Message-ID: <4AD3A460.6060505@zytor.com>
Date: Mon, 12 Oct 2009 14:49:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
References: <4AC97C00.7090503@kernel.org> <200910061257.54877.bjorn.helgaas@hp.com> <20091012203453.GC7648@elte.hu> <200910121545.47794.bjorn.helgaas@hp.com>
In-Reply-To: <200910121545.47794.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 02:45 PM, Bjorn Helgaas wrote:
> For the patch in question, we don't even have a root cause for the bug
> (or at least, I couldn't decipher it from the changelog). There's a 
> reference to _CRS being wrong, but we don't currently use _CRS for
> x86 host bridges.
> 
> But in general, my objection is that even if BIOS provides perfectly
> valid information about host bridge apertures, the the fact that Linux
> ignores that information means we have to add this sort of vendor-
> specific code every time we trip over something. And we're tripping
> over things quite often.
> 
> Windows consumes this _CRS information, so while I grant there are
> certainly BIOS bugs there, I think most of the bugs are actually in
> Linux.

I think the right policy for most if not all things should be "use the
BIOS information unless we know better."

	-hpa

