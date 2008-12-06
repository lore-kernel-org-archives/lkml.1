Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYLFRQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYLFRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYLFRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:16:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbYLFRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:16:16 -0500
Date: Sat, 6 Dec 2008 09:15:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] PCI: Suspend and resume PCI Express ports with
 interrupts disabled
In-Reply-To: <200812061508.00277.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812060914100.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061505.33815.rjw@sisk.pl> <200812061508.00277.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> I don't see why the suspend and resume of PCI Express ports should be
> handled with interrupts enabled and it may even lead to problems in
> some situations.

Absolutely. A PCI Express port is really just a PCI bridge, with some odd 
rules. We need to enable them early, exacly like regular PCI bridges, or 
we cannot walk the PCI bus hierarchy correctly.

Anyway, ack, ack, ack for the whole series.

			Linus
