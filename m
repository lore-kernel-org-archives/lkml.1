Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZBQIwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZBQIwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZBQIwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:52:36 -0500
Received: from smtp2.ono.com ([62.42.230.20]:16810 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbZBQIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:52:36 -0500
Date: Tue, 17 Feb 2009 09:52:32 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mdv Cooker <cooker@mandrivalinux.org>
Subject: Bonding tied to IPV6 in 29-rc5
Message-ID: <20090217095232.5da06b9f@werewolf.home>
In-Reply-To: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain>
References: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0cvs64 (GTK+ 2.15.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

Don't know if this is specific for -rc5, I have jumped from 28.4 to 29-rc5.
In this latest kernel, I can not install 'bonding' module if 'ipv6' is
disabled to load via modprobe.conf:

install ipv6 /bin/true

Trying bonding gives this dmesg:

bonding: Unknown symbol ndisc_build_skb
bonding: Unknown symbol in6_dev_finish_destroy
bonding: Unknown symbol ndisc_send_skb
bonding: Unknown symbol unregister_inet6addr_notifier
bonding: Unknown symbol register_inet6addr_notifier

Commenting the line in modprobe.conf makes things smooth again.
We can not disable ipv6 anymore ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
