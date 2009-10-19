Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZJSRrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZJSRrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZJSRrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:47:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:45388 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZJSRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u9uYgmnacBHyyb+au4tFndy3JaFUKQeMB6WzMwwtkhmLCczPyF4ztVDmn0cQ8gHZAw
         VWiUm+r3FFzHWDStCO0Ej7IKfL9reggcRCC1udEmcqndhIGX5NRh/XSUHw1YafHtfln7
         1j0+gH849n/8x5RUIu7+MuO7Ow9biTyQYJZEo=
Date: Mon, 19 Oct 2009 19:47:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf tools: Add missing
	tools/perf/util/include/string.h
Message-ID: <20091019174730.GA4880@nowhere>
References: <1255972296-11500-1-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255972296-11500-1-git-send-email-acme@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 03:11:36PM -0200, Arnaldo Carvalho de Melo wrote:
> To cure a bunch of:
> 
> In file included from util/include/linux/bitmap.h:1,
>                  from util/header.h:8,
>                  from builtin-trace.c:7:
> util/include/../../../../include/linux/bitmap.h:8:26: error: linux/string.h: No such file or directory
> make: *** [builtin-trace.o] Error 1
> make: *** Waiting for unfinished jobs....



Hmm, while exporting some headers, I saw that some kernel headers inclusion didn't
triggered any warning although they were including headers for which I hadn't
put any stub, so they couldn't find it.

So it looks like my gcc is sometimes missing such problems. Sorry.

Thanks.

