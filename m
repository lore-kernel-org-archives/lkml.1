Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758950AbYLQHeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYLQHeV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYLQHeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:34:11 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41158 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYLQHeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:34:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=YRns74qPOlzanWaaURnZlXiU33GwJ8Fh8Pjg12fOKA4vS1ukRxHe1hbCDtBInudByE
         PAxpBuuQITwJBuIf1tiSYNi7bjJS6Gw1w3PIaWFhEONNc/knTpDnrp/o7EnT6kw6ewa1
         JmJl4MzVGFxf5A570CcsHUo2PnfziBkbfq9SE=
Message-ID: <7c86c4470812162334v4515563fq8f27d5b6f381108e@mail.gmail.com>
Date: Wed, 17 Dec 2008 08:34:07 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch] Performance Counters for Linux, v4
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric Dumazet" <dada1@cosmosbay.com>,
        "Robert Richter" <robert.richter@amd.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
        perfctr-devel@lists.sourceforge.net
In-Reply-To: <18760.13407.568536.198724@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081214212829.GA9435@elte.hu>
	 <18758.18810.350923.806445@cargo.ozlabs.ibm.com>
	 <1229437341.7025.11.camel@twins>
	 <18760.13407.568536.198724@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Wed, Dec 17, 2008 at 12:06 AM, Paul Mackerras <paulus@samba.org> wrote:
>
> I think we need a "full-time" attribute for counters and groups that
> says "I need to be on the whole time", where "whole time" means
> whenever the task is running, for a per-task counter or group, or
> continuously for per-cpu counters/groups.
>
Who would want not to be the only owner of the PMU?

Especially when you know that if you don't, you may be sharing it
with another user who may perturb your measurement, for instance
because of heavy sampling while you are just counting. It is a tradeoff
between flexibility and accuracy. Which one is more important?
