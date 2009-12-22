Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZLVPku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZLVPku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZLVPkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:40:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbZLVPks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:40:48 -0500
Date: Tue, 22 Dec 2009 10:39:56 -0500
From: Jason Baron <jbaron@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
Message-ID: <20091222153955.GD3308@redhat.com>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 12:32:06PM +0100, Jiri Olsa wrote:
> Hi,
> 
> as I use dynamic debug sometimes, I thought it could be useful having
> the possibility to store the output somewhere else than dmesg.
> 
> The attached patch implements support for storing dynamic debug
> messages to the ring buffer.
> 
> The dynamic debug allows simple addition of new flags,
> so I added 'r' flag for ring buffer storage.
> 
> I used the ring buffer implementation from trace framework.
> 
> hopefuly this could be any use for others as well...
> plz let me know what you think,
> 
> jirka
> 

hi,

I like the idea of using the ring buffer for output. However, I'm not
sure why we need a separate one for this. I like adding the 'r' for ring
buffer storage, by why not just make this path call 'trace_printk()', and
store the string in the existing kernel tracing ring buffer? That way it
can interleave with other trace data as well.

thanks,

-Jason
