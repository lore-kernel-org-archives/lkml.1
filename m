Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYKGTe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYKGTe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYKGTet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:34:49 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35799 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYKGTes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:34:48 -0500
Date: Fri, 7 Nov 2008 11:34:33 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, khali@linux-fr.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/5] adt7462: New hwmon driver
Message-ID: <20081107193433.GA8800@plum>
Reply-To: djwong@us.ibm.com
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com> <20081107185626.13022.59407.stgit@elm3a70.beaverton.ibm.com> <1226084691.11596.42.camel@brick> <20081107112731.cec03a04.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107112731.cec03a04.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:27:31AM -0800, Andrew Morton wrote:
> > > +#define ROUND_DIV(x, divisor)  (((x) + ((divisor) / 2)) / (divisor))
> > 
> > DIV_ROUND_UP ?
> 
> That's different.  This one should be called ROUND_CLOSEST or something
> like that.

Actually, there _is_ such a macro in include/linux/kernel.h, but it does
a double-eval naughty just like mine.  That said, no need to bloat the
source tree, so I can reroll, and possibly even fix the kernel macro.

--D
