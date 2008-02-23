Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYBWP2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYBWP2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYBWP2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:28:34 -0500
Received: from smtp-out.google.com ([216.239.33.17]:59163 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYBWP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:28:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=n3hLlkP122ZvTTNA7WeLKy5WRTbXx5VbjqlGpYntBetsRBmv/HkZEvt5I/4jxLDI8
	jCrmhK5Ay5ga1LWHR4BnQ==
Message-ID: <6599ad830802230728v131093d0kd90db61df142c67@mail.gmail.com>
Date: Sat, 23 Feb 2008 07:28:28 -0800
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Cpusets API: Update cpusets to use cgroup structured file API
Cc: pj@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080223000631.f4c1dbf4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220045408.289180000@menage.corp.google.com>
	 <20080220050032.396158000@menage.corp.google.com>
	 <20080223000631.f4c1dbf4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:06 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  It is unclear to me what the relationship is between this and your other
>  cgroup pseudo-fs changes, but as this is fiddling with a userspace
>  interface we should get a wiggle on - we don't want to let things like this
>  slip out to 2.6.26.
>
>  So..  please resend everything?
>

Yes, will do.

But (given that no-one seems to like the proposed cgroup.api file)
these patches don't actually change the userspace API at all - it's
purely internal plumbing improvements.

Paul
