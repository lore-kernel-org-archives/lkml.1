Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZIYKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZIYKo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZIYKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:44:25 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49593 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZIYKoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X7qUhX7eVd3c4ti81tira5bh0jE5wFOC0O8iq7EyieXoNVEWNkf/iz8nVmXGNNMKNe
         72puE1n3XDI3W8+BUme4ZVqFeokOYcefPGgZs6QE/BugoBKdDxPNDaqGstul/7RKdi9J
         1vejMgif4aG4n06z7aySgmEwWb2bXR3arfkEg=
Date: Fri, 25 Sep 2009 12:44:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20090925104423.GB6467@nowhere>
References: <20090925122556.2f8bd939@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925122556.2f8bd939@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 12:25:56PM +0200, Arjan van de Ven wrote:
> From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 25 Sep 2009 12:20:57 +0200
> Subject: [PATCH] perf_core: provide a kernel-internal interface to get to performance counters
> 
> There are reasons for kernel code to ask for, and use, performance counters.
> For example, in CPU freq governors this tends to be a good idea, but there
> are other examples possible as well of course.
> 
> This patch adds the needed bits to do enable this functionality; they have been
> tested in an experimental cpufreq driver that I'm working on, and the changes
> are all that I needed to access counters properly.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>



Sounds like a very good idea. I have that as an ad-hoc part in the
hw-breakpoint patchset. This patch would help me drop this part
and use such unified in-kernel users interface.

Frederic.

