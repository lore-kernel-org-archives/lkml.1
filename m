Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYHZMOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYHZMOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYHZMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:14:35 -0400
Received: from il.qumranet.com ([212.179.150.194]:48363 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYHZMOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:14:34 -0400
Message-ID: <48B3F3A9.8030709@qumranet.com>
Date: Tue, 26 Aug 2008 15:14:33 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>	<20080826095032.GA309@elf.ucw.cz>	<48B3D579.40502@qumranet.com> <20080826113317.520cbab1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080826113317.520cbab1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It seems excessive.  Most machines will hardly run without acpi.
>>     
>
> *Recent* machines.
>   

Most machines are recent machines.

If a machine doesn't have acpi, this change is safe.

If a machine has acpi, but doesn't have the reset register set in the 
FADT, this change is safe.

If a machine has acpi, and the reset register is set incorrectly, this 
change is safe.

If a machine has acpi, and the reset register is wired to the launch 
controller, then perhaps this change is unsafe.  Don't issue sysrq-b on 
such machines.

-- 
error compiling committee.c: too many arguments to function

