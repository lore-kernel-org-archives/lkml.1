Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbXJKKZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbXJKKZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbXJKKYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:24:03 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:5607 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbXJKKX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:mime-version:content-type:content-transfer-encoding:x-mailer:in-reply-to:references:message-id;
        b=agwh0Pou6G/FxptpgxQ9uB/M+TNxW8eX25tXN7syts3ST8gMAa2h3Dj0u/mDSZ+z7b4esjjNDsH9Z8KvA3myuBVo38Xap1hbJjYKHvt5wesIBobilCsoBeCg8SUiupKea5XUbNdBd7T/duE8kguO5y8NxOM1opV3zPwwsX0ZPPs=
From: Ken Sugawara <sugaken.r3@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softdog - panic instead of reboot, kernel 2.6.22.9
Date: Thu, 11 Oct 2007 19:25:11 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 4.69 (WinNT,501)
In-Reply-To: <20071010131543.7da15e67@the-village.bc.nu>
References: <7DC80B08BC13EBsugaken.r3@gmail.com> <20071010131543.7da15e67@the-village.bc.nu>
Message-Id: <81C80BF10115AEsugaken.r3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>> analysis.  Provided that timer interrupts are not blocked, this patch 
>> might enable them to get a crash dump in such a situation by activating 
>> softdog.
>
>You want the NMI based anti lockup stuff for that. If the box locks up
>then generally softdog will fail. The NMI based debug
>(CONFIG_DETECT_SOFTLOCKUP) is the option you want.

Thanks for your comment.  I'll look into it, but unfortunately, most of 
our customers are running much older kernels (e.g. 2.6.9-based from 
RHEL4.x) which don't have the option, and some non-negligible number of 
them are running on non-IA platforms, whereas right now the option seems 
to be implemented only in i386 and x86_64 (correct me if I'm wrong).

Anyways, I'll try to look for a way to manually trigger NMI on their non
-IA boxes, preferably without any additional hardware.

Regards,

Ken
