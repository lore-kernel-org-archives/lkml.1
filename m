Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbZE0Sjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbZE0Sjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762940AbZE0Sjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:39:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:42528 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762377AbZE0Sja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Exv5yayCoT/CP9NWid/a6ohT9xF21dv5/zvDRHBL2C6lNHOGDd97AStA8ngL2bJtY7
         y0tkQoc1g7kiFYAHZRKr8bPPMWnlfnNp6kWhcvESxYj7Dp3eaS1qihgglg/zW5pG0e8v
         snJs4VvuY7lGyPYkzGTm78rs32F+ZCLUQvbQU=
Date: Wed, 27 May 2009 22:39:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Smith <danms@us.ibm.com>
Subject: Re: [RFC v16][PATCH 41/43] c/r: (s390): expose a constant for the
	number of words (CRs)
Message-ID: <20090527183837.GB31930@x200.localdomain>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu> <1243445589-32388-42-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243445589-32388-42-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:33:07PM -0400, Oren Laadan wrote:
> We need to use this value in the checkpoint/restart code and would like to
> have a constant instead of a magic '3'.
> 
> Changelog:
>     Mar 30:
>             . Add CHECKPOINT_SUPPORT in Kconfig (Nathan Lynch)
>     Mar 03:
>             . Picked up additional use of magic '3' in ptrace.h
> 
> Signed-off-by: Dan Smith <danms@us.ibm.com>
> ---
>  arch/s390/Kconfig |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 2eca5fe..bf62cad 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -49,6 +49,10 @@ config GENERIC_TIME_VSYSCALL
>  config GENERIC_CLOCKEVENTS
>  	def_bool y
>  
> +config CHECKPOINT_SUPPORT
> +	bool
> +	default y if 64BIT
> +
>  config GENERIC_BUG
>  	bool
>  	depends on BUG

Changelog and content aren't compatible.
