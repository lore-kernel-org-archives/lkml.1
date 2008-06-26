Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbYFZP31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbYFZP31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbYFZP3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:29:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:55214 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbYFZP3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZcpRCzEOSRuLG7bbBV4rBaUPJMsVz4YCRPZJIdDIWSy2QQAhOYptZrUOgyOZS/nK9D
         +5YNmI3ijnNzhdysKjDENSLPsg1nBjwQA6D/rtW8TDukddnHE3xXFpmxT2BxH6vf2aqx
         O2M6bE91tdBL739crumSdGoD2lWMQTL7m/5EE=
Subject: Re: [PATCH] Remove experimental status of kdump on PPC64
From: Josh Boyer <jwboyer@gmail.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: linuxppc-dev@ozlabs.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com
In-Reply-To: <1214485035-26041-1-git-send-email-bwalle@suse.de>
References: <1214485035-26041-1-git-send-email-bwalle@suse.de>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 11:28:52 -0400
Message-Id: <1214494132.2791.0.camel@weaponx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 14:57 +0200, Bernhard Walle wrote:
> This patch removes the experimental status of kdump on IA64. kdump is on IA64
> now since more than one year and it has proven to be stable.

I think you mean PPC64?

josh

> For i386/x86_64, a similar patch has been accepted by Ingo Molnar and Vivek
> Goyal.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/powerpc/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 3934e26..2a116b9 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -308,8 +308,8 @@ config KEXEC
>  	  strongly in flux, so no good recommendation can be made.
>  
>  config CRASH_DUMP
> -	bool "Build a kdump crash kernel (EXPERIMENTAL)"
> -	depends on PPC_MULTIPLATFORM && PPC64 && EXPERIMENTAL
> +	bool "Build a kdump crash kernel"
> +	depends on PPC_MULTIPLATFORM && PPC64
>  	help
>  	  Build a kernel suitable for use as a kdump capture kernel.
>  	  The kernel will be linked at a different address than normal, and

