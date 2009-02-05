Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbZBENzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbZBENzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZBENzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:55:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZBENzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:55:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090118161041.40608174@infradead.org>
References: <20090118161041.40608174@infradead.org> <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <1231887933-17843-5-git-send-email-zbr@ioremap.net> <20090114215810.674569fc.akpm@linux-foundation.org> 
To: Arjan van de Ven <arjan@infradead.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [4/7] dst: thread pool.
Date: Thu, 05 Feb 2009 13:55:27 +0000
Message-ID: <2892.1233842127@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote:

> > 2: David Howells' "slow work" infrastructure
> 
> this one is *weird*. The infrastructure deals with object refcounting
> somehow. 

The slow-work facility keeps a reference on the object you've asked it to call
a function to be called upon until it has finished calling that function.
This simplifies the object handling code a lot, and allows you to avoid
slow-work synchronisation requests in object destructors.

David
