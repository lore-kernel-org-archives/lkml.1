Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYJTWxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYJTWxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYJTWxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:53:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34352 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYJTWxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:53:23 -0400
Date: Mon, 20 Oct 2008 20:53:18 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield() options
Message-ID: <20081020225318.GA10352@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>, david@lang.hm,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 20, 2008 at 03:34:07PM -0700, david@lang.hm escreveu:
> I've seen a lot of discussion about how sched_yield is abused by  
> applications. I'm working with a developer on one application that looks  
> like it's falling into this same trap (mutexes between threads and using  
> sched_yield (or more precisely pthread_yield()) to let other threads get  
> the lock)
>
> however I've been having a hard time tracking down the appropriate  
> discussions to forward on to the developer (both for why what he's doing  
> is bad, and for what he should be doing instead)
>
> could someone point out appropriate mailing list threads, or other  
> documentation for this?

http://kerneltrap.org/Linux/Using_sched_yield_Improperly

- Arnaldo
