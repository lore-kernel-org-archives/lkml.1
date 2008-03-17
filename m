Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYCQFQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYCQFQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYCQFQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:16:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:44331 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYCQFQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gHdcg7OVn/9HG9r+X8HEP42QYACCaNfjpy79oUfEbjOXSQQvPvp+r2QHGv6219t3dFpqgD2vmhxUwGZ5HZ3WIiDBVHZX8l4n4QmNYTnFALlKFXXV4tNYN68Xi062xrXTOj5Ni1w+ey3CiGiw3dwmjWoC0bmzU3M7hGa+Hci2if4=
Message-ID: <2c0942db0803162216r1892782bsc894d4188b51481b@mail.gmail.com>
Date: Sun, 16 Mar 2008 22:16:36 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "LKML," <linux-kernel@vger.kernel.org>
In-Reply-To: <200803171144.35479.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803111749.29143.nickpiggin@yahoo.com.au>
	 <200803121221.37234.nickpiggin@yahoo.com.au>
	 <1205308704.8514.197.camel@twins>
	 <200803171144.35479.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: b77929098080eaf6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 5:44 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>  I don't see how it is really helpful for interactive processes either.
>  By definition, if they are not CPU bound, then they should be run
>  quite soon after waking up; if they are CPU bound, then reducing
>  efficiency by increasing context switches is effectively going to
>  increase their latency anyway.

How? Are you saying that switching the granularity to, say, 25ms, will
*decrease* the latency of interactive tasks?

And the efficiency we're talking about reducing here is due to the
fact that tasks are hitting cold caches more times per second when the
granularity is smaller, correct? Or are you concerned by another
issue?

> Can this be changed by default, please?

Not without benchmarks of interactivity, please. There are far, far
more linux desktops than there are servers. People expect to have to
tune servers (I do, for the servers I maintain). People don't expect
to have to tune a desktop to make it run well.
