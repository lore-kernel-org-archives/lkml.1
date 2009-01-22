Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbZAVRDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbZAVRDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZAVRDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:03:09 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:40998 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZAVRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:03:08 -0500
Message-ID: <4978A6C1.5000003@birkenwald.de>
Date: Thu, 22 Jan 2009 18:02:57 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       stefan.bader@canonical.com, Suresh Jayaraman <sjayaraman@suse.de>,
       Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
       Steve French <smfrench@gmail.com>
Subject: Re: [linux-cifs-client] BUG: Possible cifs+IPv6-Regression 2.6.27.4
 -> 2.6.27.9
References: <20090118221329.GA12742@pest>	<20090118210314.30832598@tleilax.poochiereds.net>	<20090119103248.GA28699@schleppi.birkenwald.de>	<20090119160725.34124637@tleilax.poochiereds.net>	<20090119213819.GA6532@pest> <20090122094517.42e724e4@barsoom.rdu.redhat.com>
In-Reply-To: <20090122094517.42e724e4@barsoom.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeff,

> I think I may see the bug...
> 
> I think the "addr" struct in cifs_mount is too small for ipv6 addresses.
> Here's a proposed patch for 2.6.27.y. Could you apply it and let me
> know if it fixes the bug?

Sorry, I was out of town, I'll build a kernel asap.

Stefan confirmed the bug (on i386 platform, apparently x86_64 did not 
expose the broken behaviour) and the bug fixed at Ubuntu with your 
patch. See https://bugs.launchpad.net/bugs/318565 . So I assume he 
tested it and it fixed the problem, but I'll test as well myself.

Thanks!
Bernhard
