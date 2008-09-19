Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbYISPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbYISPXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYISPXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:23:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:63312 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYISPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=sxc6fk+6KqYjjQrjKMLZm4/dIusaSaW78lncKcJ+As8cN9w5WueW9RJh25BayaYwv1
         HKPUFBQcJaeNoJNvDn5PTxrnjHWNI5K8P3JhK+pFaumr3+t/41Kvb6ivD4HRr5rYxaoR
         O9VMEsoZ62CwQKEIXpOFwL/M9u8dnTEDkApgU=
Message-ID: <2f11576a0809190823t233c6f57m48bd9724a85234a6@mail.gmail.com>
Date: Sat, 20 Sep 2008 00:23:10 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [patch 3/4] cpu alloc: The allocator
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
In-Reply-To: <20080919145929.158651064@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919145859.062069850@quilx.com>
	 <20080919145929.158651064@quilx.com>
X-Google-Sender-Auth: 3ddc9716c111a572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Allocate an object of a certain size
> + *
> + * Returns a special pointer that can be used with CPU_PTR to find the
> + * address of the object for a certain cpu.
> + */
> +void *cpu_alloc(unsigned long size, gfp_t gfpflags, unsigned long align)

cpu_alloc is good name?
I think some person suspect cpu-hotplug related function.

per_cpu_alloc() or cpu_mem_alloc() are wrong?
