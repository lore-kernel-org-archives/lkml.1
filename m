Return-Path: <linux-kernel-owner+w=401wt.eu-S936838AbYD1TCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936838AbYD1TCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937032AbYD1TBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:01:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:61526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966358AbYD1TBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TtdjgJbh5mRtQXKPaJCzZKI4GM4lnWGPXzN+IF/T6VOlMmsgMdl/HZrItxYJQhguuaz4L9sxS+B7g6PqwBh/VTL9mPEh5obtDdFBh3NbLH8dXtiKRw/Hk6Shcf4wcaUH9JbfsPX5GEZiq5DNzghjigK5Bi/ZO5m6TKQppBFguO0=
Message-ID: <2f11576a0804281201v1f5d0c1dufa7328bdd4d41f3d@mail.gmail.com>
Date: Tue, 29 Apr 2008 04:01:36 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for sched-devel.git
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080428114758.bcc08eef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080424150324.802695381@polymtl.ca>
	 <1209238735.6441.4.camel@lappy>
	 <20080428113610.b2d1e8e4.akpm@linux-foundation.org>
	 <20080428184050.GA23391@infradead.org>
	 <20080428114758.bcc08eef.akpm@linux-foundation.org>
X-Google-Sender-Auth: d549494f4a183551
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > > It hides the cosmetically-ugly bits, but not the deeply ugly: each of these
>  > > trace points is an extension to the kernel->userspace API, with all that
>  > > this implies.
>  >
>  > Not at all.  It's only accessibe to kernel code, so it per defintion
>  > can't be a userspace API.
>
>  eh?  It adds human-readable printk strings.

Yes, human-readable.
but I think trace point shouldn't be treat as kernel API.
because it cause showed implementation detail become impossible.

so, it decrease valuable of trace point.

example, nobody hope crash command hidden implementation detail.
I hope trace point is treated as so too.
