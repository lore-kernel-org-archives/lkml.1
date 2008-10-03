Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYJCRaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYJCRaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYJCRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:30:43 -0400
Received: from xenotime.net ([66.160.160.81]:54162 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751614AbYJCRam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:30:42 -0400
Date: Fri, 3 Oct 2008 10:30:33 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Uwe Hermann <uwe@hermann-uwe.de>
cc: linux-kernel@vger.kernel.org, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc: Fix broken references to Documentation/x86 files
In-Reply-To: <20081003160825.GA26167@greenwood>
Message-ID: <Pine.LNX.4.64.0810031027070.18240@shark.he.net>
References: <20081003160825.GA26167@greenwood>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Uwe Hermann wrote:

> The Documentation/i386 and Documentation/x86_64 directories and their
> contents have been moved into Documentation/x86. Fix references to
> those files accordingly.
> 
> Signed-off-by: Uwe Hermann <uwe@hermann-uwe.de>
> 
> diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> index b0c7b6c..1b1512f 100644
> --- a/Documentation/x86/x86_64/boot-options.txt
> +++ b/Documentation/x86/x86_64/boot-options.txt
> @@ -143,7 +143,7 @@ Non Executable Mappings
>  SMP
>  
>    additional_cpus=NUM Allow NUM more CPUs for hotplug
> -		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
> +		 (defaults are specified by the BIOS, see Documentation/x86/x86_64/cpu-hotplug-spec)

This file needs one more line patched.  It still contains this:

   pirq=...	 See Documentation/i386/IO-APIC.txt

so change that one also and then you can add
  Acked-by: Randy Dunlap <rdunlap@xenotime.net>
to it if you want to.

Thanks.
-- 
~Randy
