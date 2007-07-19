Return-Path: <linux-kernel-owner+w=401wt.eu-S965581AbXGSRWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581AbXGSRWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940618AbXGSRWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:22:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940532AbXGSRWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:22:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Date: Thu, 19 Jul 2007 19:22:34 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <200707191913.27946.ak@suse.de> <1184865339.6458.21.camel@dhcp193.mvista.com>
In-Reply-To: <1184865339.6458.21.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191922.34388.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 19:15:38 Daniel Walker wrote:
> On Thu, 2007-07-19 at 19:13 +0200, Andi Kleen wrote:
> > > What about using the cycles2ns() clocksource helpers, it would eliminate
> > > the duplication of the shift/multiply math .
> > 
> > They are completely different from what clocksource provides.
> 
> How so?

The new sched_clock's works CPU local and relative to the last sync point. 

-Andi
