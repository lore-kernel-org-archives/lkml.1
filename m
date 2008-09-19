Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYISO2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYISO2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYISO2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:28:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbYISO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:28:45 -0400
Message-ID: <48D3B6E4.90206@linux-foundation.org>
Date: Fri, 19 Sep 2008 09:27:48 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080918233648.581696416@quilx.com>	 <20080918233701.599037712@quilx.com>	 <84144f020809190058j425eb995y7f441da18079dc8d@mail.gmail.com>	 <48D3A4F5.9010804@linux-foundation.org> <1221833529.15030.1.camel@penberg-laptop>
In-Reply-To: <1221833529.15030.1.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Fri, 2008-09-19 at 08:11 -0500, Christoph Lameter wrote:
>> I thought we could handle early boot panics with early_printk?
> 
> Sure, but *if* we can limp along it's usually much nicer to debug
> WARN_ONs that trigger during early boot. But anyway, I'm fine with
> either way.

How would you do this?

if (condition) {
	WARN_ON(1);
	return NULL;
}

or do we have a macro for this situation.

if (WARN(condition))
	return NULL;

?

