Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbYBHTYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbYBHTYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbYBHTX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:23:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:52732 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761561AbYBHTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:23:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=m/zFi4E5NnAa2hOzxxNtiZUOiuxjgLe0MRFMUFUeHQUt0F2G97IKKli1ljo3r55xdQsTJHsjHmt1vNj7ugCTgzIGZfr5nOBdNtjnSA38yoayAETOj7CYMa1Bs6YFsiNMBaTdcsl1R7CL6/ABypdjsCdrTRIcb5iaXco2Jc2oxZo=
Date: Fri, 8 Feb 2008 22:23:43 +0300
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, akpm@osdl.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] exporting capability code/name pairs (try #4)
Message-ID: <20080208192343.GA15571@martell.zuzino.mipt.ru>
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC23F1.5030300@ak.jp.nec.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 06:42:09PM +0900, Kohei KaiGai wrote:
> [kaigai@saba ~]$ ls -R /sys/kernel/capability/
> /sys/kernel/capability/:
> codes  names  version
> 
> /sys/kernel/capability/codes:
> 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
> 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
> 
> /sys/kernel/capability/names:
> cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
> cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
> cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
> cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
> cap_dac_read_search  cap_mac_override      cap_setuid      cap_sys_resource
> cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
> cap_fsetid           cap_net_admin         cap_sys_boot    cap_sys_tty_config
> cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
> cap_ipc_owner        cap_net_broadcast     cap_sys_module
> [kaigai@saba ~]$ cat /sys/kernel/capability/codes/20
> cap_sys_pacct
> [kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_mknod
> 27
> [kaigai@saba ~]$
> --------------------------------------------------------
> Any comment please.

You don't like 1 (one) /proc/capabilities, why?
