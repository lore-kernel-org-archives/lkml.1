Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbYCLB1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbYCLB1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYCLB1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:27:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61644 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYCLB1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:27:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cvnN7kVA9187i/OWWDMTUhkbAug79V1yBwi8qyXVirugHes9j5xAQ1qO1rSvTDEfp
	vfYKV/T2X+EzBuo6jV/bw==
Message-ID: <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
Date: Tue, 11 Mar 2008 18:27:10 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: boot cgroup questions
Cc: "Paul Jackson" <pj@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47D73086.2030008@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D73086.2030008@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 6:23 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>  The thing is though that the very next thing we do there is run early
>  userspace. Which begs the question, shouldn't we just do it from early
>  user-space then ?

Seems simplest to me. We have an early boot script that creates a
"system" cpuset and moves all tasks into it. It seems to work fine for
us.

Paul
