Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZLNMkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZLNMkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZLNMkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:40:01 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63462 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZLNMkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uLmPBgydjX3q2pVJ0b300SOxZ/SXb7LYNO0aBCtAPeCuOdjr7kgdm5H22OCHipi8t0
         47a09ABsjJA+vmlQdATOn4BhlV9KEiWSzfSUbo4ByIgqk1TY8dGsmrp5bWXF0sbgA9WX
         /9/PXWb+ZgnJk9rouChNMkkS6YZjZhWdzUaV4=
Date: Mon, 14 Dec 2009 13:39:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] tracing: Fix bugs in string filters.
Message-ID: <20091214123955.GK5168@nowhere>
References: <4B25B797.1040201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B25B797.1040201@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:57:11AM +0800, Li Zefan wrote:
> This patchset fixes some bugs in string filters.
> 
> A new string helper strnstr() is introduced, to be used in
> middle matching callback.
> 
> Also I add some comments to mainly explain why we should use
> length-limited version of strstr() and strcmp().
> 
> ---
>  include/linux/string.h             |    5 ++++-
>  kernel/trace/ftrace.c              |    6 +++---
>  kernel/trace/trace_events_filter.c |   29 ++++++++++++++++++++---------
>  lib/string.c                       |   27 ++++++++++++++++++++++++++-
>  4 files changed, 53 insertions(+), 14 deletions(-)


Looks pretty good.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

