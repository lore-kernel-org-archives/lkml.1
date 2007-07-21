Return-Path: <linux-kernel-owner+w=401wt.eu-S1765965AbXGUNlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765965AbXGUNlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbXGUNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:40:52 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39714 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbXGUNkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:40:51 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 21 Jul 2007 09:38:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: jidong xiao <jidong.xiao@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: what does select statement mean in Kconfig file?
In-Reply-To: <4104961b0707210634gea4e240x11b043b4e64c7840@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707210938190.22394@localhost.localdomain>
References: <4104961b0707210634gea4e240x11b043b4e64c7840@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, jidong xiao wrote:

> Hi,
> for example, what does the select statement mean?
>
> config SERIAL_SH_SCI_CONSOLE
>        bool "Support for console on SH SCI(F)"
>        depends on SERIAL_SH_SCI=y
>        select SERIAL_CORE_CONSOLE
>
> Thanks
> Jason Xiao

it forces the selection of that option.  it's sort of like a "depends
on" in reverse.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
