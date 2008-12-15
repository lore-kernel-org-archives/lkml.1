Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYLOU6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYLOU6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYLOU6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:58:14 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56509 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYLOU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ZEYkPps5Va+o38+kxWMTftCxDtt4M7p29eco5sgBQms17pPbmbWcUIdXXS5uPVzz3z
         Ur/mshOngE2ws3rtZD9Z4jc6si4+dmwB2z4itNtZLBQXZBCMWLrm5RtDnEq8LyuWihqU
         U/8G5pgfKaU4ta3YXC/JxKPNkx5HbeBmCeig8=
Message-ID: <7c86c4470812151258m11b7185sbd629a82c91778bb@mail.gmail.com>
Date: Mon, 15 Dec 2008 21:58:10 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vince Weaver" <vince@deater.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Paul Mackerras" <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20081214231332.GA26942@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	 <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
	 <20081214231332.GA26942@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 15, 2008 at 12:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
> We've implemented the essence of these variants, with sharing the resource
> being the sane default, and with the sysadmin also having a configuration
> vector to reserve the resource to himself permanently. (There could be
> more variations of this.)
>
Reading the v4 code, it does not appear the sysadmin can specify which
resource to reserve. The current code reserves a number of counters.
This is problematic with hardware where not all counters can measure
everything, or when not all PMU registers are counters.
