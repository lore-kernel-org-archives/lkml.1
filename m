Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbYGOQOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbYGOQOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYGOQOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:14:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40343 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbYGOQOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:14:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JN5RQ+LpI90VNezueMfJJRP8sgCpUrX52djR/Pkv6xyWx/2SdqPBxUtiSSPz8v4+j
	Zw05KHraSS2zc3BYRcjig==
Message-ID: <6599ad830807150914h152e3716n914dfa5e28288d28@mail.gmail.com>
Date: Tue, 15 Jul 2008 09:14:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any context
Cc: mingo@elte.hu, pj@sgi.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
In-Reply-To: <1216122293-4888-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216122293-4888-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 4:44 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> From: Max Krasnyanskiy <maxk@qualcomm.com>
>
> I do not really like the current solution of dropping cgroup lock
> but it shows what I have in mind in general.

I think that dropping the cgroup lock will open up races for cpusets.
The idea of a separate workqueue/thread to do the sched domain
rebuilding is simplest.

Paul
