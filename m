Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYBLBOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYBLBOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYBLBOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:14:23 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62645 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYBLBOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:14:22 -0500
Message-ID: <47B0F1EE.7040003@ak.jp.nec.com>
Date: Tue, 12 Feb 2008 10:10:06 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, akpm@osdl.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] exporting capability code/name pairs (try #4)
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <20080208192343.GA15571@martell.zuzino.mipt.ru>
In-Reply-To: <20080208192343.GA15571@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Fri, Feb 08, 2008 at 06:42:09PM +0900, Kohei KaiGai wrote:
>> [kaigai@saba ~]$ ls -R /sys/kernel/capability/
>> /sys/kernel/capability/:
>> codes  names  version
>>
>> /sys/kernel/capability/codes:
>> 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
>> 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
>>
>> /sys/kernel/capability/names:
>> cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
>> cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
>> cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
>> cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
>> cap_dac_read_search  cap_mac_override      cap_setuid      cap_sys_resource
>> cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
>> cap_fsetid           cap_net_admin         cap_sys_boot    cap_sys_tty_config
>> cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
>> cap_ipc_owner        cap_net_broadcast     cap_sys_module
>> [kaigai@saba ~]$ cat /sys/kernel/capability/codes/20
>> cap_sys_pacct
>> [kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_mknod
>> 27
>> [kaigai@saba ~]$
>> --------------------------------------------------------
>> Any comment please.
> 
> You don't like 1 (one) /proc/capabilities, why?

I have no preference whether a single /proc/capabilities, or the current approach.
However, this idea requires a bit more cost to lookup a capability not sequencially.

Thank,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
