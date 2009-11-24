Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZKXHo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZKXHo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZKXHo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:44:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:17934 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZKXHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:44:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=INImlkIdlxeKQyNOEldmz7P3nFByiYvzveAJ587eHaz8Q2Hc/+2OGWiIT3SaR5r5Mp
         H/ceYP1MXwG1HMnq93JAcXTLleEDyi7QPVpX92Jsd/hulus4iBatSb8TVm5NMcM797HV
         iMkx8EZ21FwOxT4wG5v+/jI0UI84MFmmzyFkE=
MIME-Version: 1.0
In-Reply-To: <20091124073426.GA21991@elte.hu>
References: <4B0B6E44.6090106@cn.fujitsu.com>
	 <84144f020911232315h7c8b7348u9ad97f585f54a014@mail.gmail.com>
	 <20091124073426.GA21991@elte.hu>
Date: Tue, 24 Nov 2009 09:45:00 +0200
X-Google-Sender-Auth: 5ec080527512b907
Message-ID: <84144f020911232345j75c93ec6mf1fc426262c14eb0@mail.gmail.com>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more 
	statistics
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Nov 24, 2009 at 9:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Certainly we can postpone it, as long as there's rough strategic
> consensus on the way forward. I'd hate to have two overlapping core
> kernel facilities and friction between the groups pursuing them and
> constant distraction from having two targets.

Sure, like I said, I think "kmem perf" is the way forward. The only
reason we did kmemtrace userspace out-of-tree was because there was no
perf (or ftrace!) at the time and there wasn't much interest in
putting userspace tools in the tree.

I hope that counts as a "rough strategic consensus" :-)
