Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYJICpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYJICpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 22:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYJICpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 22:45:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:32753 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbYJICpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 22:45:40 -0400
Message-ID: <f488382f0810081945m4baea256odec9474869834a49@mail.gmail.com>
Date: Wed, 8 Oct 2008 19:45:38 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: paulmck@linux.vnet.ibm.com
Subject: Re: kernel BUG at kernel/sched_rt.c:322!
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
In-Reply-To: <20081009011456.GB10188@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081009011456.GB10188@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2008 at 6:14 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> When I enable:
>
>        CONFIG_GROUP_SCHED=y
>        CONFIG_FAIR_GROUP_SCHED=y
>        CONFIG_USER_SCHED=y
>
> and run a bash script onlining and offlining CPUs in an infinite loop
> on x86 using 2.6.27-rc9, after about 1.5 hours I get the following.

Is this a regression between 2.6.27-rc8 and -rc9, or did it crop up earlier?

- Steven
