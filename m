Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXKDNkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXKDNkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbXKDNkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:40:46 -0500
Received: from rayleigh.systella.fr ([213.41.184.253]:56922 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbXKDNkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:40:45 -0500
Message-ID: <472DCBBB.1040806@systella.fr>
Date: Sun, 04 Nov 2007 14:40:11 +0100
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux sparc64; fr-FR; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Sun, 04 Nov 2007 14:40:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> # ps auxww | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
> 
> After several days/weeks, this is the second time this has happened, 
> while doing regular file I/O (decompressing a file), everything on the 
> device went into D-state.

	Same observation here (kernel 2.6.23). I can see this bug when I try to 
synchronize a raid1 volume over iSCSI (each element is a raid5 volume), 
or sometimes only with a 1,5 TB raid5 volume. When this bug occurs, md 
subsystem eats 100% of one CPU and pdflush remains in D state too. What 
is your architecture ? I use two 32-threads T1000 (sparc64), and I'm 
trying to determine if this bug is arch specific.

	Regards,

	JKB
