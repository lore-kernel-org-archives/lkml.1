Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbXK2UGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbXK2UGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbXK2UFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:05:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759437AbXK2UFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:05:53 -0500
Date: Thu, 29 Nov 2007 15:04:31 -0500
From: Dave Jones <davej@redhat.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129200431.GH12481@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <lenb@kernel.org>
References: <20071124175112.58193424@morte> <200711241948.58881.rjw@sisk.pl> <20071124194635.58f5a44b@morte> <200711242031.26134.rjw@sisk.pl> <20071129095034.24b3fc59@morte> <20071129103511.GD10577@elte.hu> <20071129174548.GC12481@redhat.com> <20071129185743.46daa8ad@morte> <20071129182402.GE12481@redhat.com> <20071129202546.7a65a13c@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129202546.7a65a13c@morte>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 08:25:46PM +0100, Stefano Brivio wrote:
 > On Thu, 29 Nov 2007 13:24:02 -0500
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > On Thu, Nov 29, 2007 at 06:57:43PM +0100, Stefano Brivio wrote:
 > 
 > >  > Do you want me to comment out adjust_jiffies() and see what happens?
 > >  
 > > Just for laughs, why not.
 > 
 > I wanted to laugh, but the behaviour didn't change at all. How boring.

Unless I'm missing something obvious, this would exonorate cpufreq
as a cause, which would seem odd based upon your earlier diagnosis.

deeply confused.

	Dave

-- 
http://www.codemonkey.org.uk
