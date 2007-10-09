Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbXJIRlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbXJIRlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXJIRlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:41:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:11154 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbXJIRlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a3Y95KKvrPRsezvrsma+67K5LXsyFv+cyNYLMUQM/RUTmpZyMvp2WfuAqgw4LI50iu1uq88hamtgIsoDhJJkCoxRVpspJSkjxAJF89W0DtTYaukCTPJRQeDnel4rBQRd8b6bXJWQwyANNOcYtGBJOoXY5r7B6skeibMhwHiFOh8=
Message-ID: <84144f020710091041t61242935x4f78fda03d322720@mail.gmail.com>
Date: Tue, 9 Oct 2007 20:41:15 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <20071009161328.GA6470@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071009161328.GA6470@APFDCB5C>
X-Google-Sender-Auth: 641b427299095886
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On 10/9/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> This is because init_alloc_cpu_cpu() is called every time when the CPU is
> going to be onlined but init_alloc_cpu_cpu() is not intented to be called
> twice or more for same CPU. Then it breaks kmem_cache_cpu_free list for
> the CPU.
>
> This patch removes init_alloc_cpu_cpu() from cpu hotplug notifier. But
> call it for each possible CPUs not only online CPUs at initialization time.

Looks good to me!

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
