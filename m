Return-Path: <linux-kernel-owner+w=401wt.eu-S934698AbXK3CFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbXK3CFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXK3CFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:05:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55478 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbXK3CFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:05:37 -0500
Date: Thu, 29 Nov 2007 18:04:49 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: kondemand: kernel BUG at kernel/workqueue.c:258!
Message-ID: <20071129180449.2fcecc83@laptopd505.fenrus.org>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE2FA920@orsmsx423.amr.corp.intel.com>
References: <474F3248.3040808@gmail.com>
	<924EFEDD5F540B4284297C4DC59F3DEE2FA920@orsmsx423.amr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 13:47:34 -0800
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

>  
> 
> >-----Original Message-----
> >From: Jiri Slaby [mailto:jirislaby@gmail.com] 
> >Sent: Thursday, November 29, 2007 1:43 PM
> >To: Pallipadi, Venkatesh; Nakajima, Jun
> >Cc: Linux kernel mailing list
> >Subject: kondemand: kernel BUG at kernel/workqueue.c:258!
> >
> >Hi,
> >
> >while trying to evoke another bug by endlessly change 
> >governors, this appeared:
> >kernel BUG at .../kernel/workqueue.c:258!
> >invalid opcode: 0000 [1] PREEMPT SMP
> >CPU 0
> >Modules linked in: iwl3945 mac80211 cfg80211 tun 
> >cpufreq_userspace rfcomm
> >l2cap hci_usb bluetooth kvm_intel arc4 ecb blkcipher kvm cryptomgr
> >crypto_algapi acpi_cpufreq fglrx(P) asus_laptop sr_mod cdrom ehci_hcd
> >uhci_hcd battery
> >Pid: 443, comm: kondemand/0 Tainted: P        2.6.23 #38
> 
> Kernel version?


on the same line as the tainted flag and 2 below the binary module that
is in use.... I assume Jiri is now working on reproducing this
untainted ... ;)
