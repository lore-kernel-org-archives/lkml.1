Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZLXHaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZLXHaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 02:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZLXHaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 02:30:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:58378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbZLXHaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 02:30:14 -0500
Message-ID: <4B331957.7030906@kernel.org>
Date: Thu, 24 Dec 2009 16:33:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: fengxiangjun <fengxiangjun@neusoft.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net> <4B30134C.1050609@gmail.com> <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net> <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com> <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net> <4B31DB17.4050509@kernel.org> <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
In-Reply-To: <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 06:29 PM, fengxiangjun wrote:
> 
> Hi,
> 
> with this patch, the problem still exists.
> 
> ata1.01: XXX debounce start, SStatus=4
> ata1.01: XXX debounce done, SStatus=4, DET stable for 520 msecs
> ata1.00: SATA link down (SStatus 0 SControl 301)
> ata1.01: SATA link down (SStatus 0 Scontrol 300)
> ...
> VFS; cannot open root device ...
> 
> The kernel just panic, and I can't see what's the messege printing before 
> that.
> 
> So, I tried 'console=ttyS0 console=tty1'，full dmesg attached。

Can you please capture full failing log?  In the attached log, ata1.00
is detected successfully.

Thanks.

-- 
tejun
