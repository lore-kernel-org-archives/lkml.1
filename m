Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZHKBBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZHKBBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 21:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZHKBBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 21:01:48 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:42242 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZHKBBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 21:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=utf3yknx3SD9/Ke92KCXn7m4rqJA8M2Zlq33IXTeVvIRk69KBscL/JR4NRaz03hG90
         o24t+1plw16E0D7VqxhF0/IKrVUUMYiWILuUDwABJkJ/J9bFxSHhk5kt3uEx5xnEL3tQ
         TP/BNdPUiTQObbZctRLComlHLLjPfK7OCfbsM=
Message-ID: <4A80C2F8.2040208@gmail.com>
Date: Mon, 10 Aug 2009 19:01:44 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
In-Reply-To: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2009 05:30 PM, Luis Fernando Planella Gonzalez wrote:
> Hi.
> I can't remember since when I've started seeing this, but since 2.6.23
> or 2.6.24, I think.
> Nowadays, I'm on Ubuntu 9.04, which is kernel 2.6.28.
> I'm flooded by the message: "do_IRQ: 0.91 No irq handler for vector"
> when in TTY.
> This is really annoying for text-base operation or in distros like
> sidux, where KDE watches syslog and shows a notification for every new
> line.
> Believe me, there are thousands of such notifications...
> Here is the dmesg results just after logging in:
> http://ubuntuforums.org/showpost.php?p=7759222&postcount=2 (yes, I've
> posted it in ubuntu forums with no succes ;)
> In this log, it's possible to see that the first time do_IRQ
> complains, it says: "do_IRQ: 0.99 No irq handler for vector". All
> others are for 0.91.
> I've tried adding the noirqbalance argument to kernel, and messed with
> everything related to IRQ in the BIOS with no success...
> Anybody, please help!!!
> --

What do /proc/interrupts and lspci -vv look like?
