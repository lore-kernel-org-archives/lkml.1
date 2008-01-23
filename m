Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYAWQlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYAWQlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYAWQlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:41:03 -0500
Received: from 1wt.eu ([62.212.114.60]:1527 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYAWQlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:41:01 -0500
Date: Wed, 23 Jan 2008 17:10:44 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080123161044.GA30286@1wt.eu>
References: <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080117225744.GL8244@cosmic.amd.com> <478FE733.2030806@i4.informatik.rwth-aachen.de> <20080121232709.GJ10837@cosmic.amd.com> <20080121233226.GA1052@1wt.eu> <20080122201524.GA16428@1wt.eu> <20080122210858.GD5241@cosmic.amd.com> <20080122211530.GC16717@1wt.eu> <20080123163646.GM5241@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123163646.GM5241@cosmic.amd.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 09:36:46AM -0700, Jordan Crouse wrote:
> > Why not just ajust the constant in MFGPT_HZ since it's the only place (aside
> > the comments) where this is referenced ?
> > 
> > If you want I can send you a patch and adjust the comments at the same time.
> 
> That would be great.

OK will do ASAP.

> I think not allowing MFGPT timers for broken BIOSen is the right way to go.
> We can do  just-in-time detection the first time one of the drivers (timer
> tick or watchdog) asks for a timer, instead of the current way of probing
> automatically.
> 
> That way, you can go merrily on your way if you don't try to use any of
> the MFGPTs.  TinyBIOS users can compile out CONFIG_GEODE_MFGPT_TIMER and
> boot.

I like this method a lot. At least, people with broken bioses would have
trouble only if they modprobe geodewdt or do such things. They will easily
find the relation between their action and the problem. Right now, we only
know that it hangs after "NET: ...".

> I'll write up a patch.

Fine.

Thanks,
Willy

