Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbZDQBKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbZDQBKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZDQBK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:10:29 -0400
Received: from gw.goop.org ([64.81.55.164]:41513 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbZDQBK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:10:29 -0400
Message-ID: <49E7D701.9090407@goop.org>
Date: Thu, 16 Apr 2009 18:10:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: mathieu.desnoyers@polymtl.ca
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca>
In-Reply-To: <20090417003931.846405986@polymtl.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this helps.  rcupdate_types.h uses preempt_disable/enable, 
but doesn't include linux/preempt.h for them - but someone's going to 
have to, so you've got an implicit dependency on the user to #include 
the right headers in advance.

    J
