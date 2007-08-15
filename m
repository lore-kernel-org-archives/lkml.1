Return-Path: <linux-kernel-owner+w=401wt.eu-S936052AbXHOT6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936052AbXHOT6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbXHOT6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:58:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43886 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbXHOT6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:58:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46C35AE1.3020904@s5r6.in-berlin.de>
Date: Wed, 15 Aug 2007 21:58:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <46C2350A.1010807@redhat.com> <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <20070815081841.GA16551@osiris.boeblingen.de.ibm.com> <46C30540.2070603@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151941150.16414@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708151941150.16414@enigma.security.iitk.ac.in>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed Cc)

Satyam Sharma wrote:
> [PATCH] ieee1394: Fix kthread stopping in nodemgr_host_thread
> 
> The nodemgr host thread can exit on its own even when kthread_should_stop
> is not true, on receiving a signal (might never happen in practice, as
> it ignores signals). But considering kthread_stop() must not be mixed with
> kthreads that can exit on their own, I think changing the code like this
> is clearer. This change means the thread can cut its sleep short when
> receive a signal but looking at the code around, that sounds okay (and
> again, it might never actually recieve a signal in practice).

Thanks, committed to linux1394-2.6.git.
-- 
Stefan Richter
-=====-=-=== =--- -====
http://arcgraph.de/sr/
