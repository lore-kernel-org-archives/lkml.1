Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXGBX5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXGBX5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXGBX5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:57:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:34379 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756811AbXGBX5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:57:04 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX180AVcAhdE0Qd9ZjQt1zCb5T944047YOzDJBpQorE
	S/2kv2x1wUkno3
Date: Tue, 3 Jul 2007 01:59:02 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Tim Boneko <tim@boneko.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Old bug in tg3 driver unfixed?
Message-ID: <20070702235901.GA9713@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Tim Boneko <tim@boneko.de>, linux-kernel@vger.kernel.org
References: <46864736.3090108@boneko.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46864736.3090108@boneko.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.30 14:06:14 +0200, Tim Boneko wrote:
> Hello!
> I am not subscribed to this list so please CC answers to my mail
> address. THX!
> 
> I recently replaced the mainboard of one of my servers with a Tyan
> Tomcat K8E. The onboard gigabit NIC is a Broadcom BCM5721. After
> compiling and loading the tg3 driver in Kernel 2.6.21.5, the interface
> could not be configured: "Device not found".
> While searching the net i found a few other people with the same problem
> but no solution.
> 
> By coincidence i found that a simpe "ifconfig eth1" worked OK and
> afterwards the device could be configured and used as desired. After
> searching this list, i found this posting
> 
> http://uwsg.iu.edu/hypermail/linux/kernel/0409.0/0224.html
> 
> by someone with obviously the same problem.

Sounds more like a iftab/udev problem. Check /etc/iftab and your udev
rules please.

Björn
