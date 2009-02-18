Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZBRSC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZBRSC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZBRSCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:02:46 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:35570 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbZBRSCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:02:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMFAAjam0lMQWt2/2dsb2JhbACBbtNFhBMG
Date: Wed, 18 Feb 2009 13:02:32 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       pierre-marc.fournier@polymtl.ca
Subject: Moving Userspace RCU (urcu) from GPL to LGPL license
Message-ID: <20090218180232.GA21389@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:49:56 up 48 days, 17:48,  4 users,  load average: 1.06, 0.61,
	0.45
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I think that it would be good to distribute the userspace rcu work we
are currently doing (ref. :
http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git) as a
LGPL library rather than GPL so it can be linked to the userspace part
of the LTTng tracer. We want to provide this tracer as a LGPL library so
proprietary applications can link to it and therefore be traceable. The
only thing is that we cannot put GPL code into a LGPL library.

The other point is that I use a few low-level primitives from the Linux
kernel header (e.g. atomic increment for x86, barrier macros). Those are
simple one-liners, but, still, I wonder about the licensing
implications. I could simply "rewrite" them, but that would be a shame
to have a different primitive implementation of those simple primitives
in userspace and in kernel-space just for a licensing question. I would
really like to keep the Linux kernel coding-style within this library.
So the question would be : are those headers, distributed with the Linux
kernel, distributed under GPL license ? Is there any special clause that
would permit using their content under LGPL ? If not, would the
community see such use favorably ?

Ideas/comments are welcome.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
