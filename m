Return-Path: <linux-kernel-owner+w=401wt.eu-S935830AbXHIBja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935830AbXHIBja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbXHIBjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:39:22 -0400
Received: from mx1.suse.de ([195.135.220.2]:56488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbXHIBjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:39:21 -0400
To: Greg Trounson <gregt@maths.otago.ac.nz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	<46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org>
	<20070804192130.GA25346@elte.hu>
	<20070804211156.5f600d80@the-village.bc.nu>
	<20070804202830.GA4538@elte.hu>
	<20070804224834.5187f9b7@the-village.bc.nu>
	<20070805071320.GC515@elte.hu> <46BA6667.1070205@maths.otago.ac.nz>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Aug 2007 04:33:39 +0200
In-Reply-To: <46BA6667.1070205@maths.otago.ac.nz>
Message-ID: <p73lkclfncs.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Trounson <gregt@maths.otago.ac.nz> writes:

> mount [fs] -o remount,noatime,nodiratime

nodiratime is implied in noatime.

> I get a compile time of 1m23.368s, a mere 6% improvement.

6% is nothing to sneeze at. A lot of optimizations would kill for less

-Andi
