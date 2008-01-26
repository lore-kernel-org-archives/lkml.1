Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYAZTY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYAZTY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 14:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYAZTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 14:24:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37630 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYAZTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 14:24:48 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479B87B9.8080005@s5r6.in-berlin.de>
Date: Sat, 26 Jan 2008 20:19:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: preemptible RCU bug (was Re: [git pull] scheduler changes for v2.6.25)
References: <20080125203740.GA31784@elte.hu>
In-Reply-To: <20080125203740.GA31784@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>  - Paul E. McKenney's preemptible RCU code.

BUG:  New Kconfig option without help text.

$ make oldconfig
RCU implementation type:
> 1. Classic RCU (CLASSIC_RCU) (NEW)
  2. Preemptible RCU (PREEMPT_RCU) (NEW)
choice[1-2]: ?

Sorry, no help available for this option yet.
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/
