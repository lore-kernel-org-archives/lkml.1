Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbXGaVtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbXGaVtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759035AbXGaVsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:48:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:22384 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbXGaVsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:from:cc:content-type:mime-version:references:content-transfer-encoding:message-id:in-reply-to:user-agent;
        b=SaOOkeFGQRqgXVos4JMtg6jMPm/q4/XTx5+wSLf2MAhfrvtKtrbqqqQ4uy4lfacSNbrorVcwsMkNgohlzkXjmOtKHqffdZxecYnV06vTdJbLVaX4f8YfgeImvePJbCSKk+YJ3uqPnv+rAsElfiRs2UHPuKy+sB1sQno+VQSeKRQ=
Date: Tue, 31 Jul 2007 23:48:47 +0200
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: Reboot hang
From: kriko <kristjan.ugrin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site> <46AFABE8.7050107@gmail.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.twcmvlvcatcbto@linux.site>
In-Reply-To: <46AFABE8.7050107@gmail.com>
User-Agent: Opera Mail/9.22 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> "Summary screen" will do, but yes, I understood. Perhaps your BIOS isn't  
> fond of the state the Linux drivers leaves your DVD-ROM at. Judging by  
> your "nv_pata", you are probebly usiing the pata (pata_amd) driver, not  
> the old IDE driver?
>
> Does it boot through if you disable booting from the DVD-ROM?
>
> Rene.

Mentioning the dvd-rom state, it comes to my mind, when rebooting from  
win, the dvd rom will close tray and  / or LED will blink on reboot.
None of that happens if I reboot from linux, so it could be a driver  
problem. I see that I have both (old and new enable in kernel), I don't  
know which is being used,
but I'll recompile kernel with just one driver and retest.

-- 
kriko
