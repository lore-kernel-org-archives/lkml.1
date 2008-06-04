Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbYFDQbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbYFDQbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYFDQa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:30:59 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:48150 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYFDQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:30:58 -0400
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 12:30:58 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Date: Wed, 4 Jun 2008 18:18:27 +0200
User-Agent: KMail/1.9.9
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
References: <20080601213019.14ea8ef8.pj@sgi.com> <4844BB41.7000605@qualcomm.com> <4845D825.6000403@qualcomm.com>
In-Reply-To: <4845D825.6000403@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041818.29709.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

On Wednesday 04 June 2008, Max Krasnyanskiy wrote:
> btw Ingo, I just realized that maxcpu= option is exactly what you need.
> Here is how you can use it.
> Boot your system with maxcpus=1. That way the kernel will only bring up 
> processor 0. I'm assuming cpu0 is "good" otherwise your system is totally 
> busted :). Other cpus will stay off-line and will not be initialized.
> Then once the system boots you can selectively bring "good" processors online 
> by doing
> 	echo 1 > /sys/devices/system/cpu/cpuN/online
> 

I just tested it on the Ubuntu Hardy standard kernel on an AMD DualCore.
The /sys/devices/system/cpu/cpu1 entry doesn't show up.

I can send you the dmesg/config in private, if you want.

Did you test your suggestion? 

After our discussion, I tried to find the right spot to implement 
"disablecpus=" myself, but couldn't find the right position to hook it up.

If your idea would work out, I would ACK it. Even in bold :-)


Best Regards

Ingo Oeser
