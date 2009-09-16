Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZIPGQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZIPGQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZIPGQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:16:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27665 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZIPGQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:16:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=X5YeVvC4ml7B6GT76H/pm/ZAlLi8vSuWrPUsQ/gtxM/yTVZVuEOAMvI3c2fjWSjue
	Gf08Vs8r85VKnS+xiR4sg==
Date: Tue, 15 Sep 2009 23:16:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][mmotm] fix walk system ram range patch (Was Re: mmotm
 on powerpc: walk_memory_resource?
In-Reply-To: <20090916092644.fb53279a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0909152315380.25569@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0909152224400.29857@sister.anvils> <20090916092644.fb53279a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, KAMEZAWA Hiroyuki wrote:

> Index: mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
> ===================================================================
> --- mmotm-2.6.31-Sep14.orig/arch/powerpc/mm/mem.c
> +++ mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
> @@ -166,7 +166,7 @@ walk_system_ram_range(unsigned long star
>  	}
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(walk_memory_resource);
> +EXPORT_SYMBOL_GPL(walk_system_ram_range);
>  
>  /*
>   * Initialize the bootmem system and give it all the memory we
> 

Um, doesn't drivers/infiniband/hw/ehca/ehca_mrmw.c need to be fixed too?
