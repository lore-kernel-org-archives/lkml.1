Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYBEFgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYBEFgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYBEFgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:36:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:26897 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYBEFgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:36:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ggno/6/jQgsXgneAnLORi4xmMxnah++XCoei+QUoq2RGta3JciXqBIDMHPg41Q7eqofOzrvDism+35Sbp+2L9Cz/lzneHnO+zY3Nxu7kltrl2ntBqBerUVX07TqxBWRl37cTCgIcvf3dIpSqh1nPkIvyEhQxll8kQxbVFQ5Nafg=
Message-ID: <863e9df20802042136v5dbef855k5887e0c9cf9337d8@mail.gmail.com>
Date: Tue, 5 Feb 2008 11:06:22 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: ananth@in.ibm.com
Subject: Re: [PATCH 2/2] Kprobes: Move kprobes examples to samples/
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Anil S Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
       "David Miller" <davem@davemloft.net>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       hskinnemoen@atmel.com, "Masami Hiramatsu" <mhiramat@redhat.com>,
       sam@ravnborg.org, randy.dunlap@oracle.com
In-Reply-To: <20080205051256.GB12223@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080205051004.GA12223@in.ibm.com>
	 <20080205051256.GB12223@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/08, Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> + * Build and insert the kernel module as done in the kprobe example.
> + * You will see the trace data in /var/log/messages and on the console
> + * whenever sys_open() returns a negative value.

A passing observation...."sys_open" should be replaced with "do_fork",
whose return value is not checked at all.

--
Regards,
Abhishek
