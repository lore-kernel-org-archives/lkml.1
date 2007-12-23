Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbXLWSB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbXLWSB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 13:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXLWSBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 13:01:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988AbXLWSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 13:01:22 -0500
Date: Sun, 23 Dec 2007 09:58:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, bugme-daemon@bugzilla.kernel.org,
       Brice Goglin <brice@myri.com>
Subject: Re: [Bug 9528] x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce
 4 suspend-to-RAM
In-Reply-To: <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712230954550.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Linus Torvalds wrote:
> 
> For an example of what I mean, see the file "drivers/pci/quirks.c", and 
> check out the quirks for various chipsets:

Side note - we already do have some quirks for the CK804 chipset, we 
probably just don't have enough (ie we have it for some HT stuff, but 
there are probably different ranges for ACPI etc other registers). 

I'm adding Brice Goglin to the Cc, since he was the one that created those 
quirks, which implies that he probably has access to documentation on that 
thing.

Brice: see the unfolding sad story on

	http://bugzilla.kernel.org/show_bug.cgi?id=9528

which doesn't include Carlos' previous email, but does include my reply, 
so you can see what the resource allocation issue is..

			Linus
