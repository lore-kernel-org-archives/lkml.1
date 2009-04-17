Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbZDQAzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbZDQAzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbZDQAze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:55:34 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:53642 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760148AbZDQAzd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:55:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFAIlw50lMQW1W/2dsb2JhbACBTs5Wg30G
Date: Thu, 16 Apr 2009 20:55:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_defines.h
Message-ID: <20090417005521.GA23828@Krystal>
References: <20090417001437.215128284@polymtl.ca> <20090417001637.845737169@polymtl.ca> <20090417004352.GA1988@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090417004352.GA1988@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:54:16 up 47 days, 21:20,  2 users,  load average: 0.68, 0.84,
	0.61
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * mathieu.desnoyers@polymtl.ca <mathieu.desnoyers@polymtl.ca> wrote:
> 
> >  include/linux/rcupdate.h         |  127 ------------------------------
> >  include/linux/rcupdate_defines.h |  163 +++++++++++++++++++++++++++++++++++++++
> 
> Looks good to me (if Paul accepts it too), but please use the 
> standard convention we use in other places for 'light' headers: 
> rcupdate_types.h.
> 
> 	Ingo

Given there were not "types" declared per-se, I thought _defines was
more appropriate. But I don't mind, as long as we separate the heavy
from the "light" header. I'll repost with _types.h.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
