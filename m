Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYEFIam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYEFIam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYEFIa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:30:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59044 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYEFIa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:30:28 -0400
Date: Tue, 6 May 2008 10:30:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Pau Aliagas <linuxnow@newtral.org>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: can I receive UDP broadcasts in aliases interfaces?
In-Reply-To: <alpine.LFD.1.00.0804290021170.11820@tux.dis.ct>
Message-ID: <alpine.LNX.1.10.0805061029190.16731@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.1.00.0804290021170.11820@tux.dis.ct>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-04-29 00:27, Pau Aliagas wrote:
>
> I'm trying to use aliased interfaces to run multiple instances of a
> process that receives UDP broadcasts; I want to test all in a
> single computer when I have no access to the network.
>
> My problem is that I can bind to the virtual interface ip to send
> and receive packets, but I don't receive udp broadcasts. I have no
> firewall rules that block it and udp bcasts are generated from the
> same computer too.
>
> Is there any sysctl param I need to change? I'm usre this can be
> done but I haven't found how.

Hm, set a proper broadcast address on the address? E.g.

	ip addr add 192.168.0.137/24 brd + dev eth0
