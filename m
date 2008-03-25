Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbYCYUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbYCYUjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbYCYUiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:38:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:64171 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbYCYUit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=F90eQet9e9h4nrYwJy348CzgqZ7Ur+Q4I+GsKmMwrrnz34CZyV+bf37gbDaQQXNb4AYjyYApQ/HNsZV8/HT2GbhClvv6man01BaQXUkxYa+c+TOA61T5umZP84+BXEclWF3QhYfxuYctPW7xiC6jfaFScthkkJ7LdgDI9MUP/QU=
Message-ID: <2c0942db0803251338n47dba8e5l1364b30adbf415be@mail.gmail.com>
Date: Tue, 25 Mar 2008 13:38:44 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Subject: Re: Poor performance now? Please, put weighted velocities ctxts/s to the sched.decision!
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <998d0e4a0803251329o4dabd28ck5197838fe6920441@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0803251329o4dabd28ck5197838fe6920441@mail.gmail.com>
X-Google-Sender-Auth: abbe8ba612f11b80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 1:29 PM, J.C. Pizarro <jcpiza@gmail.com> wrote:
>  [2] "Re: Serious performance regression in Wine applications and Linux 2.6.24.*"
>  http://lkml.org/lkml/2008/3/25/181
>  On Tue, 25 Mar 2008 08:49:13 -0700, "Ray Lee" wrote:
>  > Andi's idea of looking for excessive context switches is good -- I
>  > didn't see a response to that one. Other than that, if you're only
>  > noticing the issue in 3d games, then it could be several things (not
>  > just the scheduler).
>
>  The kernel needed the velocity parameter to gain it: ctxts per interval
>  (normally ctxts/s or ctxts/minute).

We don't know that's the problem yet. The reporter is doing more testing.

>  "Please, put 64-bit counter per task and incr.by.one each ctxt switch."
>  http://lkml.org/lkml/2008/2/23/398
>  http://lkml.org/lkml/2008/2/23/401
>  http://lkml.org/lkml/2008/2/23/406
>  http://lkml.org/lkml/2008/2/24/1
>  http://lkml.org/lkml/2008/2/24/103
>  http://lkml.org/lkml/2008/2/24/157
>  http://lkml.org/lkml/2008/2/26/159

There are already counters recording the switches:
    http://lkml.org/lkml/2008/2/25/314

>  My proposal is free for yours, quasi-bastards, I won't charge you!

My parents were married.
