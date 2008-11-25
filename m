Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYKYCdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYKYCdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 21:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYKYCcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 21:32:53 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60898 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYKYCcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 21:32:52 -0500
Message-Id: <200811250232.mAP2W7B3069759@www262.sakura.ne.jp>
Subject: Re: Random freeze (Re: mmotm 2008-11-19-02-19 uploaded)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Nov 2008 11:32:07 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

mmotm 2008-11-24-16-52 booted fine. But a patch for below BUG is missing.
http://kerneltrap.org/mailarchive/linux-netdev/2008/11/22/4204804

----------
INIT: version 2.86 booting
BUG: using smp_processor_id() in preemptible [00000000] code: hotplug/1159
caller is sock_prot_inuse_add+0x1c/0x40
Pid: 1159, comm: hotplug Not tainted 2.6.28-rc6-mm1 #1
Call Trace:
 [<c0200ba4>] debug_smp_processor_id+0xc4/0xe0
 [<c027cb7c>] sock_prot_inuse_add+0x1c/0x40
 [<f8047821>] unix_create1+0x101/0x120 [unix]
 [<f8047875>] unix_create+0x35/0x70 [unix]
 [<c0279077>] __sock_create+0xf7/0x250
 [<c0279208>] sock_create+0x38/0x50
 [<c0279298>] sys_socket+0x38/0x70
 [<c027a1fd>] sys_socketcall+0x5d/0x270
 [<c0191fec>] sys_getcwd+0x11c/0x150
 [<c011af30>] do_page_fault+0x0/0x450
 [<c01034e6>] syscall_call+0x7/0xb
BUG: using smp_processor_id() in preemptible [00000000] code: hotplug/1159
caller is sock_prot_inuse_add+0x1c/0x40
BUG: using smp_processor_id() in preemptible [00000000] code: hotplug/1156
caller is sock_prot_inuse_add+0x1c/0x40
Pid: 1156, comm: hotplug Not tainted 2.6.28-rc6-mm1 #1
Call Trace:
 [<c0200ba4>] debug_smp_processor_id+0xc4/0xe0
 [<c027cb7c>] sock_prot_inuse_add+0x1c/0x40
 [<f8047821>] unix_create1+0x101/0x120 [unix]
 [<f8047875>] unix_create+0x35/0x70 [unix]
 [<c0279077>] __sock_create+0xf7/0x250
 [<c0279208>] sock_create+0x38/0x50
 [<c0279298>] sys_socket+0x38/0x70
 [<c027a1fd>] sys_socketcall+0x5d/0x270
 [<c0191fec>] sys_getcwd+0x11c/0x150
 [<c011af30>] do_page_fault+0x0/0x450
 [<c01034e6>] syscall_call+0x7/0xb
