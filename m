Return-Path: <linux-kernel-owner+w=401wt.eu-S934535AbXK3IRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbXK3IRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbXK3IQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:16:56 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:42523 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbXK3IQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:16:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oCBZX/dz21Swmi62TQuTmfKwWOam5AQzMOh58uOuwTgL07j7ZjwrcTRkH4MX9BraRDfp64r9pTEZ01kB9Cm8poYeg6A5hgcpZ/mQsfjkOHsfg0KX7I3N5fZZwwZLlwSquhEgRt+yYgL9CEb2Urm2PX7HzQx8h8TqOHpoel76ovE=
Message-ID: <474FC6EF.6050204@gmail.com>
Date: Fri, 30 Nov 2007 09:16:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: kondemand: kernel BUG at kernel/workqueue.c:258!
References: <474F3248.3040808@gmail.com>	<924EFEDD5F540B4284297C4DC59F3DEE2FA920@orsmsx423.amr.corp.intel.com> <20071129180449.2fcecc83@laptopd505.fenrus.org>
In-Reply-To: <20071129180449.2fcecc83@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2007 03:04 AM, Arjan van de Ven wrote:
> On Thu, 29 Nov 2007 13:47:34 -0800
> "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
>>> while trying to evoke another bug by endlessly change 
>>> governors, this appeared:
>>> kernel BUG at .../kernel/workqueue.c:258!
>>> invalid opcode: 0000 [1] PREEMPT SMP
>>> CPU 0
>>> Modules linked in: iwl3945 mac80211 cfg80211 tun 
>>> cpufreq_userspace rfcomm
>>> l2cap hci_usb bluetooth kvm_intel arc4 ecb blkcipher kvm cryptomgr
>>> crypto_algapi acpi_cpufreq fglrx(P) asus_laptop sr_mod cdrom ehci_hcd
>>> uhci_hcd battery
>>> Pid: 443, comm: kondemand/0 Tainted: P        2.6.23 #38
>> Kernel version?
> 
> 
> on the same line as the tainted flag and 2 below the binary module that
> is in use.... I assume Jiri is now working on reproducing this
> untainted ... ;)

I've posted it even tainted, since this happened once after 50 h of reproducing
another bug so I guess I'll never have untainted "version" of it, because I need
to use the laptop in real life too :). If Venkatesh wants to fwd it to
/dev/null, it won't bother me, maybe somebody else will come with untainted
report some later...
