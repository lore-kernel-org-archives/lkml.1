Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZLIIdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZLIIdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZLIIdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:33:31 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39422 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZLIIda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:33:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IM+kGmo8hLF5MBflj619B/qsOn2MUW2vow1eMeoRz5qGlcy96JcL+kbJ+dCyppkKsP
         IvTylz7rrsyxTepn7YdaHMCubkHCRX5a3BFv/8mGrgGDMBLf1xxxIgZ6rJ6uuJp07c5t
         BGfLWIpfP2IyxV9r9Mfe6QHxmBrvlS6z0iCLQ=
Date: Wed, 9 Dec 2009 09:33:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf_event: cleanup for __perf_event_init_context()
Message-ID: <20091209083332.GA5152@nowhere>
References: <4B1F194D.7080306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F194D.7080306@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 11:28:13AM +0800, Xiao Guangrong wrote:
> This is a cleanup patch and does:
> - define 'perf_cpu_context' variable with 'static'
> - using kzalloc() instead of kmalloc() and memset()
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---


And perf_event_init_cpu() doesn't need it as it's supposed
to be statically zeroed already.

Looks good to me.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

