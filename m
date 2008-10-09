Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbYJITQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbYJITQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbYJITQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:16:30 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:51666 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbYJITQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:16:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYFAGD07UhMQWq+/2dsb2JhbACBcr1ZgWo
Date: Thu, 9 Oct 2008 15:16:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Building a tracing userspace tool in the kernel tree
Message-ID: <20081009191626.GA29344@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:05:48 up 126 days, 23:46, 10 users,  load average: 1.04, 0.58,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

At the kernel summit, people seemed to be interested to have the basic
userspace tools required to extract and pretty-print a trace available
within the kernel tree. Therefore, what I am trying to do is something
along the lines of

ltt/usr/
ltt/usr/tracectl/    (control tracing)
ltt/usr/tracesplice/ (splice buffers to disk)
ltt/usr/tracecat/    (merge sort and format the binary buffers into
                      human-readable text)

That would however require to create a Makefile which behaves a little
bit like what scripts/ is currently doing with hostprogs-y, only that
it's different in the sense that those tools are not required to build
the kernel and this could therefore become a more standard part of the
build process than what scripts/ is.

Is there some magic statements to put in Makefile and ltt/Makefile to
get this to build nicely with the rest of the tree ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
