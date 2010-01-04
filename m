Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910Ab0ADTNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0ADTNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789Ab0ADTNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:13:33 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:53067 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab0ADTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:13:32 -0500
Date: Mon, 4 Jan 2010 14:13:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jon Bernard <jbernard@debian.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jan Blunck <jblunck@suse.de>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org,
       Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       pierre-marc.fournier@polymtl.ca
Subject: [RELEASE] Userspace RCU 0.3.3
Message-ID: <20100104191328.GA22558@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:11:16 up 19 days,  3:29,  5 users,  load average: 0.15, 0.92,
	1.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hereby announce the 0.3.3 release of the Userspace RCU library, which
includes this fix from Sebastian Andrzej Siewior for some powerpc
platforms:

Consider __NO_LWSYNC__

This is set by the gcc when the target does not support the lwsync
opcode. This is the case for e500 core based CPUs.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
