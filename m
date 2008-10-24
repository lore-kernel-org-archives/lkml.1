Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYJXRhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYJXRhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbYJXRhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:37:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22718 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYJXRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:37:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=wy227CmQ4xwqckOOdJU+17Kb/wn5kC3D+rilHzAlUf+jBfBmfV30tweREuU+lnOFG
	ILWMLiyfRL6oSu7SwNKFg==
Message-ID: <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
Date: Fri, 24 Oct 2008 10:37:34 -0700
From: "Paul Menage" <menage@google.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting controller
Cc: linux-kernel@vger.kernel.org,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081024050830.GA4387@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023054335.GC3280@in.ibm.com>
	 <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
	 <20081024050830.GA4387@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 10:08 PM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
>> > +static struct cpuacct init_cpuacct_group;
>>
>> Why are you making the root state static?
>
> Because it is not used anywhere outside sched.c. Is that a problem ?

Sorry, I wasn't clear - I mean, why are you changing it from
dynamically-allocated in cpuacct_create to statically-allocated in the
BSS?

Paul
