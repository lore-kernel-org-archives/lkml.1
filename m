Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZG2DbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZG2DbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 23:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZG2DbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 23:31:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61089 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZG2DbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 23:31:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=dCS4QvU9JJIqVieoKuCR5qZD8SjDRlIU/ALvCOH1t5xnFEClgpU/Ingb6xZtwNLnu
	jm5+CTSAi+RaEmjX3ZaQw==
Date: Tue, 28 Jul 2009 20:30:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Gregory Haskins <gregory.haskins@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [regression] sched_getaffinity fails with EINVAL in 2.6.31-rc4
In-Reply-To: <200907291118.53912.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0907282029180.28714@chino.kir.corp.google.com>
References: <4A6DE0DC.2070207@gmail.com> <alpine.DEB.2.00.0907271108350.8408@chino.kir.corp.google.com> <200907291118.53912.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009, Rusty Russell wrote:

> I argued strongly against the set and getaffinity interfaces when they were
> introduced; they can't be used in general without a loop (enlarge cpu_set,
> retry).
> 

Right, so the functional regression here is glibc 2.3.2 -> 2.3.3.
