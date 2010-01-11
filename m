Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987Ab0AKU1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0AKU1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319Ab0AKU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:27:33 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:51480 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0AKU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:27:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bcF3sRrL8Civ1aH/TwUGovYKeGSG9NR/XN+NgNGxBAUyqIUkdLvO4YTrLtN0+agdA4
         Ud7D9/yaB7aiBR9hbHRDi8dFFQvHYUC9hNouUtCgMqZpTcAetVipCiHcgO0okTooP91P
         OAvb8wr+JFzTsKisRbGD7PzJfDKp81GHWlQDI=
Date: Mon, 11 Jan 2010 23:27:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20100111202729.GI4923@lenovo>
References: <20100111191633.GT24885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111191633.GT24885@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 02:16:33PM -0500, Don Zickus wrote:
> Hi Ingo,
> 
...
> I was going to jump in and try to do this work.  I wanted to make sure
> what you were looking for here.  When you say convert nmi watchdog to perf
> events, I assume you mean merging over the bits of perfctr-watchdog.c to
> perf_events.c, modify nmi.c to just register as a normal perf event and
> probably cleanup the oprofile stuff to match, correct?
> 
> Cheers,
> Don
>

As far as I know -- converting perfctr-watchdog.c to into perfevents
style would be quite a desirable feature. But I still didn't manage to
find time for this task :( If you're interested to start this work
-- that would be just great!

	-- Cyrill
