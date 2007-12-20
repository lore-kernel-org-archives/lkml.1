Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbXLTKXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbXLTKXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 05:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXLTKWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 05:22:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63949 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbXLTKWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bURnHoZbKMxQpg1Mzq4aR39Phl0TIu44jeOIj0duemFO/BTP2TbJ41gsAoKv7jM8JxytOFRLv5z5IblRgMWKjXScZKEKPJXzcaSy7QUsklzbb4hsc4wAi66NjtMN1NmyqAgisRE+LfMqkjrfR+J4gOVR86SCF8hewn6JMXIBhRk=
Message-ID: <3f9a31f40712200222w6d617b55oec3dd8122385001d@mail.gmail.com>
Date: Thu, 20 Dec 2007 15:52:51 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/3] x86: fix kprobe_handler reenable preemption
Cc: "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       "Jim Keniston" <jkenisto@us.ibm.com>,
       "Roland McGrath" <roland@redhat.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20071220091509.GC4478@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47699194.3060809@redhat.com> <20071220091509.GC4478@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2.6.25 or v2.6.24 ?

On Dec 20, 2007 2:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
>
> > Fix a preemption bug in kprobe_handler(). It has to call
> > preempt_enable() before returning.
>
> thanks - i've applied all 3 kprobes patches from you. (for v2.6.25)
>
>        Ingo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
