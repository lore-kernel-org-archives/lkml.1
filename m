Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbXLMOwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbXLMOwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbXLMOvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:51:49 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:56055 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755010AbXLMOvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:51:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HABzWYEdMROHU/2dsb2JhbACBWqhx
Date: Thu, 13 Dec 2007 09:46:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Next patches for the 2.6.25 queue
Message-ID: <20071213144642.GA7800@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:25:22 up 39 days, 19:30,  4 users,  load average: 0.31, 0.46,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I would like to post my next patches in a way that would make it as
easy for you and the community to review them. Currently, the patches
that have really settled down are :

* For 2.6.25

- Text Edit Lock
  - Looks-good-to Ingo Molnar.
- Immediate Values
  - Redux version, asked by Rusty

* For 2.6.25 ?

Another patchset that is technically ok (however Rusty dislikes the
complexity inherent to the algorithms required to be reentrant wrt NMI
and MCE, although it's been reviewed by the community for months). I
have also replyed to Ingo's concerns about effeciency of my approach
compared to dtrace by providing numbers, but he has not replyed yet.
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg238317.html

- Markers use Immediate Values

* Maybe for 2.6.26 ...

Once we have this, and the instrumentation (submitted as RFC in the past
weeks), in the kernel, the only architecture dependent element that will
be left is the LTTng timestamping code.

And then, from that point, the following patchset is mostly
self-contained and stops modifying code all over the kernel tree. It
is the LTTng tracer.

Trying to improve my approach : I guess that submitting at most 15
patches at a time (each 1-2 days), against the -mmotm tree, would be the
way to do it ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
