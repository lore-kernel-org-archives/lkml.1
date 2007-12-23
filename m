Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXLWSBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXLWSBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 13:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbXLWSBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 13:01:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXLWSBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 13:01:37 -0500
Date: Sun, 23 Dec 2007 10:00:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-Reply-To: <200712231730.34935.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.9999.0712230959140.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712231730.34935.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Rafael J. Wysocki wrote:
> 
> The patch is fine by me, so if anyone has objections, please speak up.

There is absolutely *no* way I will apply this in an -rc6 release.

The number of machines this will break is totally unknown. It might be 
zero. It might be hundreds.  We just don't know. We might hit another 
unlucky allocation that we just happened to avoid before.

		Linus
