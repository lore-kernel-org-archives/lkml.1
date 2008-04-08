Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYDHTMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYDHTMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYDHTMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:12:32 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4052 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYDHTMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:12:31 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] introduce HAVE_EFFICIENT_UNALIGNED_ACCESS Kconfig symbol
Date: Tue, 8 Apr 2008 21:11:33 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, sam <sam@ravnborg.org>
References: <1207667127.14253.42.camel@johannes.berg>
In-Reply-To: <1207667127.14253.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804082111.35944.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 8. April 2008, Johannes Berg wrote:

> In many cases, especially in networking, it can be beneficial to
> know at compile time whether the architecture can do unaligned
> accesses efficiently. This patch introduces a new Kconfig symbol
> 	HAVE_EFFICIENT_UNALIGNED_ACCESS
> for that purpose and adds it to the powerpc and x86 architectures.
> Also add some documentation about alignment and networking, and
> especially one intended use of this symbol.

Please CC linux-arch@vger.kernel.org for such changes, so it's more likely 
noticed by more arch maintainers, so a list can be compiled what is 
appropriate for the various archs.
The scope of this symbol is IMO a little unclear, is it intended for one-time 
accesses to small object or also for repeated accesses to larger objects?
Anyway, this probably should be set for m68k as well.

bye, Roman
