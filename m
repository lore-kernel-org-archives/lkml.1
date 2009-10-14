Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbZJNU0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbZJNU0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbZJNU0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:26:43 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:37154 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933824AbZJNU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YxPnecqW40oBegaqvwQORICjEHqOtkamSoUW848j1xdAXUaJVBNU8FNJ7tg7O/zYpL
         BhaGLkRjbnd6SzET3SgGOIgz7JdXXlX/c1FD+nETAWTVn/STSBfXsIZgdDad8tifzvdz
         YgeYftdK1XvDiz8qi3WroFUjGSH85nzzTNBRc=
Date: Wed, 14 Oct 2009 22:26:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 13/13] [PATCH 13/13] perf tools: remove all char *
	typecasts and use const in prototype
Message-ID: <20091014202600.GA5133@nowhere>
References: <20091014194330.980165492@goodmis.org> <20091014194400.635935008@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014194400.635935008@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 03:43:44PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The (char *) for all the static strings was a fix for the symptom and
> not the disease. The real issue was that the function prototypes
> needed to be declared "const char *".
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---


Yep.
I know it's a shame what I did. I was just harassed by tons of
warnings when I integrated trace-cmd into perf (because of its gcc
flags) and then I was too impatient and did the wrong thing :)

Thanks.


