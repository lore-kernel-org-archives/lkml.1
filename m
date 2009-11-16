Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZKPTCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZKPTCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZKPTCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:02:18 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63398 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZKPTCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uFnRnIXChJt4Od8ldr4TivQBZGcLrQ5jKbHH4QGhtMJPxgBH69Ui6ZwyyT9vAxAd0P
         h8Aa8pRqbCtXDx/JDWtQKHgmkUKQrRxBQydtBx1CHgv8ETd8oUrpscuftVSir+PwpLeb
         y2z69ZdnxR2m4oQ+b/TDr8nroF3k8ydjv1l58=
Date: Mon, 16 Nov 2009 20:02:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/5] perf tools: Generalize perf_header__adds_read
Message-ID: <20091116190221.GC5293@nowhere>
References: <1258396365-29217-1-git-send-email-acme@infradead.org> <1258396365-29217-2-git-send-email-acme@infradead.org> <1258396365-29217-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258396365-29217-3-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 04:32:43PM -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Renaming it to perf_header__process_sections and passing a callback to
> handle each feature.
> 
> The next changesets will introduce 'perf buildid-list' that will handle
> just the HEADER_BUILD_ID table, ignoring all the other features.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>


Looks much proper this way, indeed :)

