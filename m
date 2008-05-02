Return-Path: <linux-kernel-owner+w=401wt.eu-S935515AbYEBQGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935515AbYEBQGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbYEBQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:06:42 -0400
Received: from mail.tpi.com ([198.107.51.143]:3715 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYEBQGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:06:41 -0400
Message-ID: <481B3C0E.502@tpi.com>
Date: Fri, 02 May 2008 10:06:38 -0600
From: Tim Gardner <timg@tpi.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: jeffschroeder@computer.org, Jan Engelhardt <jengelh@medozas.de>,
       Jeff Mahoney <jeffm@suse.com>, Tim Gardner <tim.gardner@canonical.com>,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       John Johansen <jjohansen@suse.de>
Subject: Re: Btrfs v0.14 Released
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com> <200805021034.08358.chris.mason@oracle.com>
In-Reply-To: <200805021034.08358.chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Friday 02 May 2008, Jeff Schroeder wrote:
> 
> [ Btrfs oops with apparmor patched in ]
> 
>> Make is not my forte, but here is a working test to see if apparmor
>> exists in Ubuntu 8.04.
>> Maybe have make apply a patch to the btrfs source if this test
>> succeeds? Does this work in SUSE?
>>
>> http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test
>> _for_btrfs.patch
>>
> 
> Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
> the kernel has the patch.  Lets go back to Jeff's suse patch:
> 
> /*
>  * Even if AppArmor isn't enabled, it still has different prototypes.
>  * Add more distro/version pairs here to declare which has AppArmor applied.
>  */
> #if defined(CONFIG_SUSE_KERNEL)
> # if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
> # define REMOVE_SUID_PATH 1
> # endif
> #endif
> 
> Could someone from Ubuntu please suggest a replacement for CONFIG_SUSE_KERNEL 
> and KERNEL_VERSION(2,6,22) that would correspond with ubuntu kernels shipped 
> with apparmor?  We don't need some define from the apparmor patch, just a 
> global flag that says it comes from ubuntu is enough.
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

To the best of my knowledge, the AppArmor patches are arch and flavour
independent. If CONFIG_SECURITY_APPARMOR exists, then the AA code is
compiled. This is certainly the case for Hardy. Neither Kees or myself
are aware of any reason why it won't also hold true for Intrepid.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
