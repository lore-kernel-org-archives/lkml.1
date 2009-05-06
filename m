Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbZEFWYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbZEFWYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763941AbZEFWYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:24:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763921AbZEFWYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:24:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090506112459.5edd0902.akpm@linux-foundation.org>
References: <20090506112459.5edd0902.akpm@linux-foundation.org> <20090502163423.GA1633@linux.vnet.ibm.com> <12234.1241558327@redhat.com> <20090506120909.GR25203@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Date: Wed, 06 May 2009 23:22:54 +0100
Message-ID: <11979.1241648574@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> More like "concerns".  It's unobvious to me that the modest .text
> savings justify the costs of an additional RCU implementation.  Where
> those costs include

It may be more than just modest .text savings.  Being optimised to be as
simple as possible, and to only support one CPU, it may be quicker too.  I'm
not sure how best to benchmark it though.

David
