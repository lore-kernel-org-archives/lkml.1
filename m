Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbYA3OvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbYA3OvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYA3OvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:51:04 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:53186 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754967AbYA3OvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:51:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALUdoEdMQWYq/2dsb2JhbACBWK41gXY
Date: Wed, 30 Jan 2008 09:50:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [BUG] x86: duplicated TIF number
Message-ID: <20080130145059.GA13000@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:46:40 up 87 days, 19:52,  6 users,  load average: 1.04, 0.89,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder if this is expected ? (in current 2.6.24-git)

commit 7e9916040b3020d0f36d68bb7512e3b80b623097
and commit eee3af4a2c83a97fff107ddc445d9df6fded9ce4

Both use the same TIF number (25) in thread_info_64.h.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
