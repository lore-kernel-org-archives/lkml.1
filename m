Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXC0NwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXC0NwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXC0NwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:52:17 -0400
Received: from flvpn.ccur.com ([66.10.65.2]:57580 "EHLO users.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbXC0NwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:52:16 -0400
X-Greylist: delayed 1893 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 09:52:16 EDT
Date: Tue, 27 Mar 2007 09:20:41 -0400
From: Tom Horsley <tom.horsley@ccur.com>
To: linux-kernel@vger.kernel.org
Cc: bugsy <bugsy@ccur.com>
Subject: TLS info and core files?
Message-ID: <20070327092041.40947947@tweety>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.8.20; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As a debugger developer, I find it quite handy when debugging
a real process to use the PTRACE_GET_THREAD_AREA or
PTRACE_GET_ARCH_PRCTL calls to dig up pthread IDs without
having to know too much about the internals of the pthread
library. (It would be even handier if the info was more
consistent across architectures :-).

In a core file, that information has all disappeared.

Should core files have NOTE entries added for some sort of
thread local storage info to be recorded? (Whatever the
kernel happens to know that won't be accessible anymore
after the process is gone, which would probably vary
from architecture to architecture.)
