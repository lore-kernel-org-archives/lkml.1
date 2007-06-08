Return-Path: <linux-kernel-owner+w=401wt.eu-S1031725AbXFHVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031725AbXFHVag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933422AbXFHVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:30:23 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:29757 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937750AbXFHVaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:30:21 -0400
X-Greylist: delayed 1344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2007 17:30:21 EDT
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Florin Iucha <florin@iucha.net>
Subject: Re: networking busted in current -git ???
Date: Fri, 8 Jun 2007 23:07:45 +0200
User-Agent: PLD Linux KMail/1.9.7
References: <20070608205640.GI30661@iucha.net>
In-Reply-To: <20070608205640.GI30661@iucha.net>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706082307.45722.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 of June 2007, you wrote:
> Hello,
>
> I am using the current git tree: 85f6038f2170e3335dda09c3dfb0f83110e87019 .
> Git tree from two days ago (with the same config) works fine.
>
> Attempting to acquire an IP address via DHCP fails with:
>
> SIOCSIFADDR: No buffer space available
> Listening on LPF/eth0/00:19:b9:0c:9a:43
> Sending on   LPF/eth0/00:19:b9:0c:9a:43
> Sending on   Socket/fallback
> DHCPREQUEST on eth0 to 255.255.255.255 port 67
> DHCPACK from xxx.xxx.xxx.xxx
> SIOCSIFADDR: No buffer space available
> SIOCSIFNETMASK: Cannot assign requested address
> SIOCSIFBRDADDR: Cannot assign requested address
> SIOCADDRT: Network is unreachable
> bound to xxx.xxx.xxx.xxx -- renewal in 98610 seconds.
>
> This is on a Dell 490 with tg3 network driver running Ubuntu 7.04 .
> .config and dmesg are appended.
>
> florin

Here it requires few retries (stop dhcpcd, start again) to get the IP. git 
tree from few hours ago. tg3 driver. I also saw SIOCSIFADDR: No buffer space 
available once.

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
