Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbYEUGZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbYEUGZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbYEUGZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:25:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:43636 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756479AbYEUGZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:25:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FBZJ6iY4Fld8pBL0jFWXZVK8obGA/jbec0UDN0T
	cElCtON4jrSF/o
Subject: Re: 2.6.24.7-rt8
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1211258763.14697.82.camel@localhost.localdomain>
References: <1211258763.14697.82.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 May 2008 08:25:04 +0200
Message-Id: <1211351104.5484.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Steven,

On Tue, 2008-05-20 at 00:46 -0400, Steven Rostedt wrote:
> We are pleased to announce the 2.6.24.7-rt8 tree, which can be
> downloaded from the location:
> 
>   http://rt.et.redhat.com/download/

I ran mysql+oltp (ro) on 2.6.24.7-rt7 and 2.6.25-rt2 to compare
throughput to their parent trees, and ended up with strange (and
verified) looking performance curves for both trees.  The changes in
2.6.24.7-rt8 and 2.6.25.4-rt3 cured the primary oddities.

(it looks to me like there may be a little load-balancing issue, peak
throughput isn't where it should be for my Q6600 box)

	-Mike

