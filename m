Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZFOMWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZFOMWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFOMV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:21:57 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:37479 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFOMV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iCz1zwy7flA97dVSXaxBVOoqUuaqmnX2kjHdsU+9hgVnucwfsJQBXczzlhw8+kSgId
         jDC20ZNfW6pmF3hWhuCXU82L0IsSy4fbU1ost5X08IbKfM/UlcZZFAoOOT8eIV9VAPjR
         o1Z1TJc+NZ01vFrKzH8smiMQ64AXEu78Y89T0=
Date: Mon, 15 Jun 2009 14:21:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] tracing: some fixes for 2.6.31
Message-ID: <20090615122152.GA6044@nowhere>
References: <4A35B84B.40904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A35B84B.40904@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:56:11AM +0800, Li Zefan wrote:
> Some small but not trival fixes for 2.6.31:
> 
> [PATCH 1/4] tracing: fix a typo in tracing_cpumask_write()
> [PATCH 2/4] tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
> [PATCH 3/4] tracing/filters: operand can be negative
> [PATCH 4/4] tracing/filters: strloc should be unsigned short
> ---
>  kernel/trace/trace.c               |    8 ++++----
>  kernel/trace/trace_events_filter.c |    9 +++++++--
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> 

Acked-by: Frederic Weisbecker <fweisbec@gmail.com> for
the whole series. Thanks!

