Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304Ab0AJTc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0AJTc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 14:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827Ab0AJTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 14:32:57 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:63922 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612Ab0AJTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 14:32:56 -0500
Date: Sun, 10 Jan 2010 14:32:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jon Bernard <jbernard@debian.org>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pedro Alves <pedro@codesourcery.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: [RELEASE] Userspace RCU 0.3.4
Message-ID: <20100110193254.GB28017@Krystal>
References: <20100104191328.GA22558@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100104191328.GA22558@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:27:54 up 25 days,  3:46,  5 users,  load average: 0.18, 0.21,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Userspace RCU 0.3.4 now supports older glibc versions with different
sched_setaffinity prototypes, contributed by Pedro Alves. I also fixed
some #define which were ending with ; , which is a bad thing when
embedded in if() else. We did not have any occurence of the problem in
the urcu code, but it was a compiler error waiting to happen.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
