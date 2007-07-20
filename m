Return-Path: <linux-kernel-owner+w=401wt.eu-S938346AbXGTIbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938346AbXGTIbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935828AbXGTI14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:27:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:56680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936285AbXGTI1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:27:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Date: Fri, 20 Jul 2007 10:27:46 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
References: <200707191154.642492000@suse.de> <1184863904.6458.17.camel@dhcp193.mvista.com> <20070720031105.GA8237@Krystal>
In-Reply-To: <20070720031105.GA8237@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201027.46532.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I noticed the same thing about interrupts off when going through the
> code.

That's only on a slow path during cpu frequency changing while the TSC is instable.
Shouldn't be that common.

-Andi
