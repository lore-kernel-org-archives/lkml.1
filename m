Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXJ1Tuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXJ1Tuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbXJ1Tuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:50:44 -0400
Received: from main.gmane.org ([80.91.229.2]:49564 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbXJ1Tuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:50:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: No module symbols loaded - kernel modules not enabled.
Date: Sun, 28 Oct 2007 20:50:18 +0100
Message-ID: <fg2p69$t4p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c416a.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get the following output from the command "head -n 7 /var/log/boot.msg".

Inspecting /boot/System.map-2.6.23.1-default
Loaded 27483 symbols from /boot/System.map-2.6.23.1-default.
Symbols match kernel version 2.6.23.
No module symbols loaded - kernel modules not enabled.

klogd 1.4.1, log source = ksyslog started.
<5>Linux version 2.6.23.1-default (root@Sonne) (gcc version 4.2.1 (SUSE Linux)) #1 SMP
PREEMPT Sun Oct 28 15:34:56 CET 2007


A lot of discussions can be found around this specific notice about symbol loading. I am
interested in an explanation for the effects on the current kernel.
Does it just mean that no debugging symbols were loaded?

Load all symbols for debugging/ksymoops (KALLSYMS):
"Say Y here to let the kernel print out symbolic crash information and
symbolic stack backtraces. This increases the size of the kernel
somewhat, as all symbols have to be loaded into the kernel image."


The following configuration option is active on my system, of course.

Automatic kernel module loading (KMOD):
"Normally when you have selected some parts of the kernel to
be created as kernel modules, you must load them (using the
"modprobe" command) before you can use them. If you say Y
here, some parts of the kernel will be able to load modules
automatically: when a part of the kernel needs a module, it
runs modprobe with the appropriate arguments, thereby
loading the module if it is available. If unsure, say Y."

Regards,
Markus

