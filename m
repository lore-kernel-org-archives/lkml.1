Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYD2Vci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYD2Vci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYD2Vca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:32:30 -0400
Received: from outbound-mail-113.bluehost.com ([69.89.24.3]:60940 "HELO
	outbound-mail-113.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751937AbYD2Vc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:32:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] PCI updates for 2.6.26
Date: Tue, 29 Apr 2008 14:32:19 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Yinghai Lu <yhlu.kernel.send@gmail.com>
References: <200804291012.21832.jbarnes@virtuousgeek.org> <20080429202632.GA4967@elte.hu>
In-Reply-To: <20080429202632.GA4967@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291432.19653.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 1:26 pm Ingo Molnar wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > Nothing really major here: some bug fixes, documentation fixes and
> > some trivial stuff for 2.6.26.  Some of the more important changes are
> > actually coming in through Ingo's "big box" tree, so the excitement
> > (and risk) level here should be pretty low.
>
> i see they are now both upstream and the combination mixed well :)
>
> there are a few other PCI items in x86.git btw that you might want to
> have a look at and which you might want to pick up into your tree - they
> dont really belong into x86.git.
>
> one would be the patch below - it gives us a boot option to enable a lot
> more port IO resource space on modern (large) systems, and increases the
> maximum number of PCI cards that Linux can support.
>
> given that true ISA cards with port decode mirroring problems are
> history on new systems, shouldnt this DMI opt-in feature be a
> default-enabled thing instead somehow? DMI really sucks for sane
> features, it does not scale at all as it always lags behind reality.
>
> Can we discover it in a robust way that the system has no chance for ISA
> cards and turn the tighter non-ISA alignment of port resources on
> automatically? [for cases where Linux does the port allocation and
> sizing]

Hm, there's some ISA stuff in ACPI, but I'm not sure how reliable that would 
be...  I'll take a look through some chipset manuals.

Jesse
