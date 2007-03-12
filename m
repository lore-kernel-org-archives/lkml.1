Return-Path: <linux-kernel-owner+w=401wt.eu-S965454AbXCLJzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454AbXCLJzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965437AbXCLJzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:55:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:17951 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965454AbXCLJzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oMwNySQogWYAmJ9JvUtcDypoYWg6shUzmmF0owZs4UcyouDiyTp220NVHh+wfNbqaX8e57dEwsWsLM9oe+584qqzL2m1qL/avmmbJ+5prvYRgvf+27jj/kpw6PAV7REG+ZN3EW8Yt+WPMYHV5P10WrI9HbJvFalo2xBKHllKyxc=
Message-ID: <661de9470703120255k4c4c1d0fy97a2b7a033c7b5b1@mail.gmail.com>
Date: Mon, 12 Mar 2007 15:25:07 +0530
From: "Balbir Singh" <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@sw.ru>, Kirill@smtp.osdl.org,
       Linux@smtp.osdl.org, containers@lists.osdl.org,
       "Paul Menage" <menage@google.com>, List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
In-Reply-To: <20070309164855.GB3647@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <20070309164855.GB3647@MAIL.13thfloor.at>
X-Google-Sender-Auth: cab770e236139369
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> doesn't look so good for me, mainly becaus of the
> additional per page data and per page processing
>
> on 4GB memory, with 100 guests, 50% shared for each
> guest, this basically means ~1mio pages, 500k shared
> and 1500k x sizeof(page_container) entries, which
> roughly boils down to ~25MB of wasted memory ...
>
> increase the amount of shared pages and it starts
> getting worse, but maybe I'm missing something here
>
> > We need to decide whether we want to do per-container memory
> > limitation via these data structures, or whether we do it via a
> > physical scan of some software zone, possibly based on Mel's patches.
>
> why not do simple page accounting (as done currently
> in Linux) and use that for the limits, without
> keeping the reference from container to page?
>
> best,
> Herbert
>

Herbert,

You lost me in the cc list and I almost missed this part of the
thread. Could you please not modify the "cc" list.

Thanks,
Balbir
