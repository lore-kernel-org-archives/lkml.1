Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZBSFS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZBSFS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 00:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZBSFSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 00:18:46 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:56263 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZBSFSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 00:18:45 -0500
Message-ID: <499CEBD7.1070000@oracle.com>
Date: Wed, 18 Feb 2009 21:19:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] [trivial] fix references to Documentation/x86/i386/boot.txt
References: <20090219015904.GH17272@bombadil.infradead.org>
In-Reply-To: <20090219015904.GH17272@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.499CEBA4.00AE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> The amazing dancing boot.txt file has jumped places again. :)
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Thanks.  I'll merge it if the x86 people don't.

> ---
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index b182626..37b6a73 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -114,7 +114,7 @@ In addition, the following text indicates that the option:
>  Parameters denoted with BOOT are actually interpreted by the boot
>  loader, and have no meaning to the kernel directly.
>  Do not modify the syntax of boot loader parameters without extreme
> -need or coordination with <Documentation/x86/i386/boot.txt>.
> +need or coordination with <Documentation/x86/boot.txt>.
>  
>  There are also arch-specific kernel-parameters not documented here.
>  See for example <Documentation/x86/x86_64/boot-options.txt>.
> @@ -2449,7 +2449,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			See Documentation/fb/modedb.txt.
>  
>  	vga=		[BOOT,X86-32] Select a particular video mode
> -			See Documentation/x86/i386/boot.txt and
> +			See Documentation/x86/boot.txt and
>  			Documentation/svga.txt.
>  			Use vga=ask for menu.
>  			This is actually a boot loader parameter; the value is


-- 
~Randy
