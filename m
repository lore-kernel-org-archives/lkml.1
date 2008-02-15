Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYBOUSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYBOUSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbYBOUSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:18:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:3977 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbYBOUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NXRirh8JoWbi2n5X6lNMVVgKdOBeSkBXzfVnm9IRIK12kQFaUE75vOWMbeBUktfvfhdY+UNw5myo73RBT2Sw7Ud3zwZGAfy7nI4ZbFBg53XqxQ2wO3QXv7egnKC3gHZuJq3BCA46c4qtATA4Vp8QoNiFTCPES2+Wf/prZHCJNJU=
Message-ID: <47B5F462.40603@gmail.com>
Date: Fri, 15 Feb 2008 21:21:54 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: Bart Van Assche <bart.vanassche@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG/ spinlock lockup, 2.6.24
References: <20080215150044.M24489@visp.net.lb> <e2e108260802150724k4e5e6089mcb603b524157a9bc@mail.gmail.com> <20080215193854.M55147@visp.net.lb>
In-Reply-To: <20080215193854.M55147@visp.net.lb>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko wrote, On 02/15/2008 08:42 PM:
...

> I have similar crashes on completely different hardware with same job (QOS), 
> so i think it is actually some nasty bug in networking.

Maybe you could try with some other debugging options? E.g. since lockdep
doesn't help - turn this off. Instead try some others, like these:

> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_HIGHMEM is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_RODATA is not set

Regards,
Jarek P.
