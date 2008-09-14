Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYINRmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYINRmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 13:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYINRm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 13:42:26 -0400
Received: from mailsvr.yanbulink.net ([79.98.184.44]:41796 "EHLO
	mail.yanbulink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYINRmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 13:42:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -4.074
Date: Sun, 14 Sep 2008 21:01:23 +0300 (AST)
From: "Wennie V. Lagmay" <wlagmay@yanbulink.net>
To: Phil Oester <kernel@linuxace.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <13415942.2991221415283525.JavaMail.root@mail.yanbulink.net>
In-Reply-To: <20080914164349.GA6664@linuxace.com>
Subject: Re: Kernel upgarde causes IPTABLES SAME not working for me
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.30.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phil,

Thank you very much for your reply. I tried using SNAT "iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SNAT --to-source 10.10.10.1-10.10.10.2" and surely this configuration can enable NATting between multiple private IP and multiple Public IP, however voice chat is not working (yahoo and msn messenger). Masquerade is working fine with voice chat however If i am not mistaken it's a multiple private to single public IP NATting. 


I have read that SAME is already obsoletes and according to an article NAT features works same as SAME but I dont know how to configure it. Can you please guide me how to use SNAT with multiple private IP to multiple Public IP that works the same as SAME target.

Again thank you very much and best regards,

Wennie

Please don't forget to put me on Cc:



----- Original Message -----
From: "Phil Oester" <kernel@linuxace.com>
To: "Wennie V. Lagmay" <wlagmay@yanbulink.net>
Cc: linux-kernel@vger.kernel.org
Sent: 14 September 2008 19:43:49 o'clock (GMT+0300) Asia/Kuwait
Subject: Re: Kernel upgarde causes IPTABLES SAME not working for me

On Sun, Sep 14, 2008 at 03:04:11PM +0300, Wennie V. Lagmay wrote:
> Dear all, 
> 
> I am having a problem with the recent version of kernel (2.6.25-14-108) on Fedora Core 9 64 bit.
> I am trying to enable the NATting using SAME command but I am getting an error "Iptables: No chain/target match by this name" but with earlier version of linux 2.6.23.1-42 iptables with SAME target is working; "iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SAME --to 10.10.10.1-10.10.10.2 --nodst"

The SAME target has been removed from the kernel, and no longer
exists in 2.6.25.  You will have to use the SNAT or MASQUERADE
targets.

Phil

