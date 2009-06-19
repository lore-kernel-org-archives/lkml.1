Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZFSTqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZFSTqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZFSTpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:45:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56144 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZFSTpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:45:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bn3GbvvLmyrKd6q8jqBdXxTohxZuBVsaTVsqCYsU7OwLcb6WuwyBLi6/0dkguuDWZ
	D1jKabIUvWh+269Nd3nEQ==
Date: Fri, 19 Jun 2009 12:45:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Miller <davem@davemloft.net>
cc: eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
In-Reply-To: <20090618.123708.78849607.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0906191239170.20822@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com> <20090618.120034.246557840.davem@davemloft.net> <alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com> <20090618.123708.78849607.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, David Miller wrote:

> > I understand what you're trying to avoid, but I disagree with the
> > approach of altering the default behavior of GFP_ATOMIC.
> 
> The default got changed at some point because it never did
> crap like this before.
> 

Wrong, the page allocator has warned about page allocation failures when 
__GFP_NOWARN was not specified since 2.5.53.  __GFP_NOWARN was never a 
default for GFP_ATOMIC.
