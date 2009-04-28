Return-Path: <linux-kernel-owner+w=401wt.eu-S1761179AbZD1Nda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179AbZD1Nda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbZD1NdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:33:18 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:13681 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbZD1NdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:33:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.379
Message-ID: <49F7059A.6000901@tremplin-utc.net>
Date: Tue, 28 Apr 2009 15:33:14 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Fabio Comolli <fabio.comolli@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OT - Regression: Cisco VPN module hangs 2.6.30-rcX
References: <b637ec0b0904280609h2583e72ds38867bdf7867a0a2@mail.gmail.com>
In-Reply-To: <b637ec0b0904280609h2583e72ds38867bdf7867a0a2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Comolli schreef:
> Hi all.
> Please forgive me if this question is considered offtopic on this
> list. I'm not sure where to post it.
> 
> Anyway, I have a regression between 2.6.30-rcX and every other version
> I tried with regards to Cisco proprietary cisco_ipsec.ko module.
> 
> The module compiles cleanly, loads and the VPN connection is created.
> So far so good. The problem is that as soon as I send packets on the
> tunnel (TCP - UDP doesn't matter, even a nslookup quesry i enough),
> the system hangs without messages on console / logs. Powercycle is
> needed.
Hello,

Have you tried using vpnc [1]? Nowadays it works very well (for
connecting to cisco VPNs) and it doesn't require you to recompile
anything whenever you change of kernel. As a bonus, it's opensource ;-)

Eric

[1] http://www.unix-ag.uni-kl.de/~massar/vpnc/
