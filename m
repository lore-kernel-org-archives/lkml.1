Return-Path: <linux-kernel-owner+w=401wt.eu-S940641AbXGSRjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940641AbXGSRjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939244AbXGSRiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:38:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:38086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762501AbXGSRiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:38:22 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Date: Thu, 19 Jul 2007 19:38:18 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <200707191922.34388.ak@suse.de> <1184866316.6458.31.camel@dhcp193.mvista.com>
In-Reply-To: <1184866316.6458.31.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191938.18988.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 19:31:56 Daniel Walker wrote:

> >From my perspective a downside to sched_clock is that the math is
> duplicated per architecture .. I think it would be a win to use the
> generic functions if it's possible..

They can't be used because they're not cpu local. The whole basic 
concept behind the new sched_clock is to be cpu local. 

-Andi
 
