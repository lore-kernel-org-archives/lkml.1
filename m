Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbXH2SqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbXH2SqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXH2SqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:46:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59888 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbXH2SqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:46:05 -0400
Subject: Re: [-mm PATCH]  Memory controller improve user interface
From: Dave Hansen <haveblue@us.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
In-Reply-To: <20070829111030.9987.8104.sendpatchset@balbir-laptop>
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 11:45:48 -0700
Message-Id: <1188413148.28903.113.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 16:40 +0530, Balbir Singh wrote:
> 
> 
> @@ -352,7 +353,7 @@ int mem_container_charge(struct page *pa
>                 kfree(pc);
>                 pc = race_pc;
>                 atomic_inc(&pc->ref_cnt);
> -               res_counter_uncharge(&mem->res, 1);
> +               res_counter_uncharge(&mem->res, MEM_CONTAINER_CHARGE_KB);
>                 css_put(&mem->css);
>                 goto done;
>         } 

Do these changes really need to happen anywhere besides the
user<->kernel boundary?  Why can't internal tracking be in pages?

-- Dave

