Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZEWNYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZEWNYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 09:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZEWNX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 09:23:56 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:45352 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbZEWNX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 09:23:56 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 61FD3E3B91
Date: Sat, 23 May 2009 15:23:54 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Andrea <andrea256it@yahoo.it>
cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: super root shell/mode/api
In-Reply-To: <607293.42795.qm@web23608.mail.ird.yahoo.com>
Message-ID: <alpine.LNX.1.10.0905231505390.28966@be10.lrz>
References: <607293.42795.qm@web23608.mail.ird.yahoo.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Andrea wrote:

>> If there is a malware with root privileges, this would be of no use. You are
>> 0wned.
>>
>> If there is a malware with user privileges, stopping these processes will
>> be enough.
>>
>> So why bother?
>
> That's exactly the problem a remote attacker or virus
> can gain root and you are completely powerless. You want
> to save data? The attacker just logs you out before you
> can run any command. You can't even backup or save
> data! You are owned. Yes.
>
> With this super shell/mode/menu in less then one second, you stop
> everything - a global SIGSTP - and gain control over your machine!

The problem is: You can only do the first step. The second step is 
prevented by the attacker replacing your super-root shell and the linux 
kernel with his specially crafted versions.

That's why you need a hypervisor or a virtual machine to do the job.

> You can save all memory, e.g. for controlling what happened
> or data recovery, sigstop without hurry all processes that seems
> a problem and so on.

You can't, since the attacker modified the "save memory" function to
exclude the malware and all your personal documents - or simply to
not work at all.
