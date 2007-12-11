Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXLKRXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXLKRXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXLKRXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:23:47 -0500
Received: from ns.suse.de ([195.135.220.2]:36496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbXLKRXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:23:46 -0500
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance overhead of get_cycles_sync
References: <475E8C8B.7070308@qumranet.com> <20071211133738.GA8150@elte.hu>
	<475E9A92.4030001@qumranet.com> <20071211142717.GA15903@elte.hu>
	<20071211083513.56c2a385@laptopd505.fenrus.org>
	<20071211170334.GA30144@elte.hu>
From: Andi Kleen <ak@suse.de>
Date: Tue, 11 Dec 2007 18:23:45 +0100
In-Reply-To: <20071211170334.GA30144@elte.hu> (Ingo Molnar's message of "Tue\, 11 Dec 2007 18\:03\:34 +0100")
Message-ID: <p73abohno0u.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org> writes:

> the TSC clocksource (and hence the vsyscall code) is turned off on 
> systems that fail the TOD/CLOCK portion of this test:

Which is not on core2 which was the question about. And if it was
turned off it wouldn't use get_cycles_sync() at all.

-Andi
