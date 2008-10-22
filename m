Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYJVRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYJVRcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJVRb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:31:58 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24242 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYJVRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:31:57 -0400
Message-ID: <48FF6389.9050408@hp.com>
Date: Wed, 22 Oct 2008 10:31:53 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, tee@sgi.com
Subject: Re: [PATCH 0/2] enable irqs when waiting for rwlocks
References: <1224664414.4430.33.camel@elijah.suse.cz>
In-Reply-To: <1224664414.4430.33.camel@elijah.suse.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
> Hello,
> 
> SGI has observed that on large systems, interrupts are not serviced for
> a long period of time when waiting for a rwlock. The following patch
> series re-enables irqs while waiting for the lock, resembling the code
> which is already there for spinlocks.

Perhaps I'm just out in left field, but that (and the similar behaviour 
for obtaining a spinlock?) feels like treating a symptom rather than a 
root cause where the root cause would appear to be long lock hold 
times/contention?

rick jones
