Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYGCTTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYGCTTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYGCTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:19:12 -0400
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:55601 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753402AbYGCTTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:19:12 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 0/11] x86/pci 32/64 bit merge
Date: Thu, 3 Jul 2008 12:19:01 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031219.01615.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 02, 2008 1:50 pm Robert Richter wrote:
> This patch series merges the x86/pci code. It's relative to
> tip/x86/cpu since there are already changes that touch pci code.
>
> I reworked parts of the subsys_initcalls to remove Makefile object
> order dependencies. The kernel reboots for acpi/noacpi, smp/nosmp,
> 32/64 bit. It compiles for numaq and visws (I don't have hardware
> available for this configurations, so please test these configs if you
> have hardware available).
>
> There is still some work to do in arch/x86/pci/amd_bus.c and for
> mmconfig.
>
> Signed-off-by: Robert Richter <robert.richter@amd.com>

In general it looks pretty nice and smaller than I would have guessed.  I'd 
like to see each change have a nicer changelog though, explaining things more 
than the one line patch summary (why, how, etc.).  And like Yinghai mentioned 
there may be other changes in the x86 tree that you have to deal with in 
order to merge this; I can pull those into my PCI linux-next tree though to 
make things easier.

Jesse
