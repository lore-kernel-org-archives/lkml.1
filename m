Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZIOLeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZIOLeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZIOLeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:34:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49330 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZIOLeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:34:12 -0400
Date: Tue, 15 Sep 2009 13:34:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] x86, perf_counter, bts: optimize BTS overflow handling
Message-ID: <20090915113408.GD1328@ucw.cz>
References: <20090908083110.A7541@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908083110.A7541@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-08 08:31:10, Markus Metzger wrote:
> Draining the BTS buffer on a buffer overflow interrupt takes too long
> resulting in a kernel lockup when tracing the kernel.

Wait. If 'takes too long' leads to 'lockup'...solution is not making
it faster. Solution should be making kernel robust -- maybe disable
tracing when it can't keep up or something...? or maybe disabling
interrupt until you handle the previous one...?
								Pavel 



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
