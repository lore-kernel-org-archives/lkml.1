Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYHaX1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYHaX1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 19:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYHaX1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 19:27:30 -0400
Received: from smtp3.ono.com ([62.42.230.176]:55517 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751664AbYHaX1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 19:27:30 -0400
Date: Mon, 1 Sep 2008 01:27:26 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5
Message-ID: <20080901012726.7c717aaf@werewolf.home>
In-Reply-To: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0cvs31 (GTK+ 2.13.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 16:26:45 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> Another week (my weeks do seem to be eight days, don't they? Very odd), 
> another -rc.
> 

r8169 is not working on an Aspire One. It looked like working some time,
but now it has begun to say:

Sep  1 01:09:35 one klogd: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Sep  1 01:09:35 one klogd: r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Sep  1 01:09:35 one klogd: r8169 0000:02:00.0: cache line size of 32 is not supported
Sep  1 01:09:35 one klogd: r8169 0000:02:00.0: PCI INT A disabled
Sep  1 01:09:35 one klogd: r8169: probe of 0000:02:00.0 failed with error -22

Any ideas ? Any more info needed ?

TIA

one:/var/log# lspci -vv -s 02:00.0
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E PCI Express Fast Ethernet controller (rev ff) (prog-if ff)
    !!! Unknown header type 7f
    Kernel modules: r8169


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
