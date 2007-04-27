Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbXD0RIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbXD0RIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbXD0RIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:08:14 -0400
Received: from colin.muc.de ([193.149.48.1]:2907 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbXD0RIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:08:12 -0400
Date: 27 Apr 2007 19:08:10 +0200
Date: Fri, 27 Apr 2007 19:08:10 +0200
From: Andi Kleen <ak@muc.de>
To: Tim Hockin <thockin@google.com>
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org, akpm@google.com
Subject: Re: [PATCH] x86_64: dynamic MCE poll interval
Message-ID: <20070427170810.GB4574@muc.de>
References: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com> <20070427090917.GA24922@muc.de> <cc96a5040704270958x8bbdb55m2fff1a4a5e1e621@mail.gmail.com> <20070427170230.GA4574@muc.de> <cc96a5040704271005p5976dec6nb7f99d6cd099de95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc96a5040704271005p5976dec6nb7f99d6cd099de95@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 10:05:58AM -0700, Tim Hockin wrote:
> On 27 Apr 2007 19:02:30 +0200, Andi Kleen <ak@muc.de> wrote:
> >On Fri, Apr 27, 2007 at 09:58:14AM -0700, Tim Hockin wrote:
> >> On 27 Apr 2007 11:09:17 +0200, Andi Kleen <ak@muc.de> wrote:
> >> >On Thu, Apr 26, 2007 at 06:02:52PM -0700, Tim Hockin wrote:
> >> >> Description:
> >> >>  This patch makes the MCE poller adjust the polling interval 
> >dynamically.
> >> >>  If we find an MCE, poll 2x faster (down to 10 ms).  When we stop 
> >finding
> >> >>  MCEs, poll 2x slower (up to check_interval seconds).  The 
> >check_interval
> >> >>  tunable becomes the max polling interval.
> >> >
> >> >Can you please fix the documentation then?
> >>
> >> Which documentation, specifically? :)
> >
> >Documentation/x86_64/{boot-options.txt,machinecheck}
> 
> What needs to be changed in boot-options?

Nothing for your patch sorry. Only in machinecheck

-Andi
