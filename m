Return-Path: <linux-kernel-owner+w=401wt.eu-S965357AbZLHCB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965357AbZLHCB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 21:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935172AbZLHCB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 21:01:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50827 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934901AbZLHCB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 21:01:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PEz7vG/Wr4H9bIw5xAE0LtoCID3BrncpCuAAinvfujfVIYWPNlnT1ZM52mTP9zpFZk
         gEtywB6ooCR6pG4LtI2PL9q/Ojx+E+kFeAAa8cUFhDZMx3Nq9i+bixBaq7J+sBT57VcK
         qj7rAR3aImA8nytJ3x/bSrmjrYyli0qCMz5Bo=
MIME-Version: 1.0
Date: Mon, 7 Dec 2009 21:01:32 -0500
Message-ID: <70438690912071801q19c566a3j38e344ef1530497@mail.gmail.com>
Subject: 2.6 kernels wrongly declare "fdiv_bug: no"
From: ZB <zbigniewbrzezinskix@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/cpuinfo fdiv_bug says "no" in 2.6.32 and other 2.6 kernels,
but 2.4 kernels say "yes" as does the Intel utility

2.4.37:
Intel Pentium with F0 0F bug - workaround enabled.
CPU: Intel Pentium 75 - 200 stepping 01
Hmm, FPU with FDIV bug.
Checking 'hlt' instruction... OK.

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 5
model		: 2
model name	: Pentium 75 - 200
stepping	: 1
cpu MHz		: 90.205
fdiv_bug	: yes
hlt_bug		: no
f00f_bug	: yes
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr mce cx8
bogomips	: 179.81


2.6.32:
Intel Pentium with F0 0F bug - workaround enabled.
[blank line here]
CPU: Intel Pentium 75 - 200 stepping 01
Checking 'hlt' instruction... OK.

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 5
model           : 2
model name      : Pentium 75 - 200
stepping        : 1
cpu MHz         : 90.199
cache size      : 0 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : yes
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8
bogomips        : 180.91
clflush size    : 32
cache_alignment : 32
address sizes   : 32 bits physical, 32 bits virtual
power management:
