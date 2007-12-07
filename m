Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXLGQxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXLGQxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbXLGQxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:53:36 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:50962 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbXLGQxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:53:35 -0500
Date: Fri, 7 Dec 2007 17:46:49 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: stefano.brivio@polimi.it, Nick Piggin <nickpiggin@yahoo.com.au>,
       Robert Love <rml@tech9.net>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207174649.39c9198d@inria.fr>
In-Reply-To: <20071207145418.GA22277@elte.hu>
References: <20071207021952.6f0ac922@morte>
	<20071207084559.GA11162@elte.hu>
	<200712072213.06530.nickpiggin@yahoo.com.au>
	<20071207122310.maqkoxlb4gsg4ggc@webmail.polimi.it>
	<20071207122516.GA25115@elte.hu>
	<20071207123509.GA28676@elte.hu>
	<20071207124034.GA30052@elte.hu>
	<20071207145418.GA22277@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 7 Dec 2007 15:54:18 +0100,
Ingo Molnar <mingo@elte.hu> a écrit :

> This is a version that 
> is supposed fix all known aspects of TSC and frequency-change 
> weirdnesses.

Tested it with frequency changes, the clock is as smooth as I like
it :-)

The only remaining sched_clock user in need of conversion seems to be
lockdep.

Great work.

-- 
Guillaume
