Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZJ2Jbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZJ2Jbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZJ2Jbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:31:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45671 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZJ2Jbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:31:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jIPxbwDgvs92YzhKbeH88R6hIKn4DE6p/N1SnOhhlvokinMmZYUH+X7sfSw0LA3DV
	jW8I2o5ShJY0OZLFHflaQ==
Date: Thu, 29 Oct 2009 02:31:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] k8.h: add struct bootnode
In-Reply-To: <20091028160955.d27ccb16.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.2.00.0910290229490.21298@chino.kir.corp.google.com>
References: <20091028190643.627f10aa.sfr@canb.auug.org.au> <20091028160955.d27ccb16.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> k8.h uses struct bootnode but does not #include a header file
> for it, so provide a simple declaration for it.
> 
> arch/x86/include/asm/k8.h:13: warning: 'struct bootnode' declared inside parameter list
> arch/x86/include/asm/k8.h:13: warning: its scope is only this definition or declaration, which is probably not what you want
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: David Rientjes <rientjes@google.com>

This is probably my fault originating from my patchset in Ingo's x86/mm 
tree with some unexpected config option combination.  Thanks Randy!

> ---
>  arch/x86/include/asm/k8.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20091028.orig/arch/x86/include/asm/k8.h
> +++ linux-next-20091028/arch/x86/include/asm/k8.h
> @@ -4,6 +4,7 @@
>  #include <linux/pci.h>
>  
>  extern struct pci_device_id k8_nb_ids[];
> +struct bootnode;
>  
>  extern int early_is_k8_nb(u32 value);
>  extern struct pci_dev **k8_northbridges;
