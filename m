Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbZKWX5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbZKWX5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbZKWX5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:57:48 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53526 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757557AbZKWX5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:57:47 -0500
Date: Mon, 23 Nov 2009 17:57:51 -0600
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/8] x86: UV - XPC fixes with related support
	functionality V2.
Message-ID: <20091123235751.GX6671@sgi.com>
References: <20091119173157.337874000@alcatraz.americas.sgi.com> <20091123180321.GB15594@elte.hu> <20091123181049.GA5220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123181049.GA5220@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regarding the patches - i still very much dislike how the code 
> interfaces to the 'BIOS'. The drivers/misc/sgi-xp/ code looks rather 
> messy.
> 
> Why isnt a pure hardware interface exposed, as both hpa and me suggested 
> in the past?

The information is stored on hardware (UV-Hub and RAM) outside this instance of hardware.

The only safe way to access that hardware is via the GRU.

No GRU resources are available to the BIOS.

Ergo, this interface method with multiple passes is needed.

If there is a better way, I am open to suggestions.

> Anyway ... these bits got merged via -mm in the past so i guess it could 
> be done there in the future too - the series does not look horrible - 
> but the whole concept ought to be done in a cleaner way.

I will ask Andrew to take them.

Thanks,
Robin
