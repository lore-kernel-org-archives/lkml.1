Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbXJWQO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbXJWQO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXJWQOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:14:53 -0400
Received: from www17.your-server.de ([213.133.104.17]:45581 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXJWQOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:14:52 -0400
Message-ID: <471E1DF0.7030008@m3y3r.de>
Date: Tue, 23 Oct 2007 18:14:40 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kexec: gets stuck in acpi_idle_enter_bm with 0895e91d60ef9bdef426d1ce14bb94bd5875870d
References: <471E194F.9010602@m3y3r.de>
In-Reply-To: <471E194F.9010602@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer schrieb:
> i try to kexec from 0895e91d60ef9bdef426d1ce14bb94bd5875870d into
> another (older) commit kernel after 2.6.23 (bisect) and the kernel gets
> stuck:
>
> PID: 0, comm: swapper
> EIP is at acpi_idle_enter_bm+0x258/0x2fa (processor)
>
> -> cpuidle_idle_call+0x5c/0x81
> -> cpuidle_idle_call+0x0/0x81
> -> cpu_idle+0xab/0xcc
> -> start_kernel+0x329/0x331
> -> unknown_bootoption+0x0/0x196
>
>
>   
2.6.23-current-git:

http://m3y3r.de/bilder/2.6.23-rc0-kexec-stuck.jpg

this seems also to happen in 2.6.23:

http://m3y3r.de/bilder/2.6.23-kexec-stuck.jpg

