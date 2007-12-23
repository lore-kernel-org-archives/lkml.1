Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbXLWWBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbXLWWBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 17:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXLWWBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 17:01:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXLWWBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 17:01:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Sun, 23 Dec 2007 23:20:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712231730.34935.rjw@sisk.pl> <alpine.LFD.0.9999.0712230959140.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712230959140.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712232320.21182.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of December 2007, Linus Torvalds wrote:
> 
> On Sun, 23 Dec 2007, Rafael J. Wysocki wrote:
> > 
> > The patch is fine by me, so if anyone has objections, please speak up.
> 
> There is absolutely *no* way I will apply this in an -rc6 release.
> 
> The number of machines this will break is totally unknown. It might be 
> zero. It might be hundreds.  We just don't know. We might hit another 
> unlucky allocation that we just happened to avoid before.

I was rather thinking of putting it into -mm for some time and target for
2.6.25 if possible.

If it breaks systems, we can always revert before 2.6.25 final.

Thanks,
Rafael
