Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZLJTe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZLJTe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZLJTeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:34:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:52842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZLJTeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:34:23 -0500
Message-ID: <4B214D00.90908@kernel.org>
Date: Thu, 10 Dec 2009 11:33:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org>	<4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk>	<20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org> <adaaaxqmxvs.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaaaxqmxvs.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > that is funny. we may need to use find early for our TRAMPOLINE...?
> 
>  > otherwise your mptable is corrupted....
> 
> Wouldn't surprise me if mptable is messed up... most likely BIOS people
> take more care to get ACPI right.
> 
> I'm not an expert on this stuff, but do we need the mptable if ACPI info
> is there?

that BIOS is using first 64k for mptable. and after booting those mptable is overwritten by trampoline.

before that happen, kernel already analyse the table and get enough info.

so when you boot with acpi=off and then try to kexec second kernel still with acpi=off, you will not get booted.

YH
