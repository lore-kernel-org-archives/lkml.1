Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZG2RCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZG2RCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZG2RCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:02:17 -0400
Received: from fifo99.com ([67.223.236.141]:38261 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZG2RCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:02:17 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090729185009.540465f6@skybase>
References: <200907291510.n6TFAV8k000647@d06av06.portsmouth.uk.ibm.com>
	 <20090729185009.540465f6@skybase>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 10:02:14 -0700
Message-Id: <1248886934.6046.1.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 18:50 +0200, Martin Schwidefsky wrote:

> void clocksource_change_rating(struct clocksource *cs, int rating)

> the two functions do different things. What exactly is the idea you've
> got in mind?

It's only the case when the rating goes to zero .. That makes the
clocksource unusable, which is very much like unregistering it..

Daniel

