Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZBPUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZBPUDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZBPUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:02:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44645 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbZBPUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:02:27 -0500
Message-ID: <4999C556.7010605@cs.helsinki.fi>
Date: Mon, 16 Feb 2009 21:58:14 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] kzfree()
References: <20090216142926.440561506@cmpxchg.org> <20090216115931.12d9b7ed.akpm@linux-foundation.org>
In-Reply-To: <20090216115931.12d9b7ed.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Mon, 16 Feb 2009 15:29:26 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
>> This series introduces kzfree() and converts callsites which do
>> memset() + kfree() explicitely.
> 
> I dunno, this looks like putting lipstick on a pig.
> 
> What is the point in zeroing memory just before freeing it?  afacit
> this is always done as a poor-man's poisoning operation.

I think they do it as security paranoia to make sure other callers don't 
accidentally see parts of crypto keys, passwords, and such. So I don't 
think we can just get rid of the memsets.

			Pekka
