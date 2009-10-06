Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbZJFO2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbZJFO2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbZJFO2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:28:18 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:61072 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932697AbZJFO2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:28:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAHnuykpMROOX/2dsb2JhbACBUtIQhCoE
Date: Tue, 6 Oct 2009 10:21:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Is RCU_PREEMPT working in 2.6.30.9 ?
Message-ID: <20091006142158.GA3951@Krystal>
References: <20091005235817.GA30691@Krystal> <20091006002441.GH6949@linux.vnet.ibm.com> <20091006020018.GA8901@Krystal> <20091006021417.GB8901@Krystal> <20091006030156.GC8901@Krystal> <20091006040235.GA6732@linux.vnet.ibm.com> <20091006051400.GA24465@Krystal> <20091006053051.GB24465@Krystal> <20091006054618.GA28121@Krystal> <20091006132831.GB6732@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091006132831.GB6732@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:34:52 up 49 days, 24 min,  2 users,  load average: 0.01, 0.07,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> Well, I am not 100% certain that we have ever gotten the combination of
> any RCU and CPU hotplug working completely correctly.  I certainly never
> have done a formal proof of the two...
> 
> 							Thanx, Paul

I just made helper tools which help finding the culprit (ends up being
vunmap). It wasn't my fault after all. ;)

Follow-up in a patchset.

Thanks,

Mathieu
 
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
