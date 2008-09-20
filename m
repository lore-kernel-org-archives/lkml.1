Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYITKwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYITKwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYITKwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:52:03 -0400
Received: from ptb-relay03.plus.net ([212.159.14.147]:54091 "EHLO
	ptb-relay03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYITKwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:52:01 -0400
Message-ID: <48D4D5CA.1060104@yahoo.com>
Date: Sat, 20 Sep 2008 11:51:54 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, lenb@kernel.org
Subject: Re: Reading EeePC900 battery info causes stalls (was Re: How how
   latent should non-preemptive scheduling be?)
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <48D4CFA5.7010501@suse.de>
In-Reply-To: <48D4CFA5.7010501@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: e0999866ad597dd600f09dbb593a0248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

Alexey Starikovskiy wrote:
> eeePC is known to be affected by EC GPE storm bug, and there is a patch 
> for 2.6.27 to workaround the problem. please look at
> http://bugzilla.kernel.org/show_bug.cgi?id=11549
> for latest patch and bugs 10724/9998 for problem discussion.

Even with http://bugzilla.kernel.org/attachment.cgi?id=17845&action=view 
(fast transaction) applied the stalls are still present (and seemingly 
just as bad as before).
