Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXLHJX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXLHJX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXLHJXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:23:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:35564 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbXLHJXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:23:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ctDyVf3Qips8nkn17Mg4BfjXpZk5pSpPDk/wCaJodF5hOHrud10zoBNQKjQcztWEWhqjyYt7dR8TzVzNzZ6C24TDHIXatFjdm7Uw4mm7NkC/q59WIXvPwDUvBokMy045mEsAgw0hsmzz8bEytAxa5OxW/LHUdL3lJwEm+QxbkN4=
Message-ID: <475A629C.7010408@gmail.com>
Date: Sat, 08 Dec 2007 10:23:40 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu>
In-Reply-To: <20071208083939.GD30997@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2007 09:39 AM, Ingo Molnar wrote:
> * Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Unfortunately no change here.
> 
> could you try to revert this change:
> 
> -int softlockup_thresh = 10;
> +int softlockup_thresh = 60;
> 
> i.e. change the value of softlockup_thresh back to 10. You should be 
> able to tweak this runtime as well, without patching the kernel:
> 
>   echo 10 > /proc/sys/kernel/softlockup_thresh

What should have this changed? I can't see any difference.
