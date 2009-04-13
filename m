Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZDMVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZDMVlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZDMVln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:41:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42981 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZDMVlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:41:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1239649429.16771.9.camel@heimdal.trondhjem.org>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Date: Mon, 13 Apr 2009 22:40:18 +0100
Message-ID: <32260.1239658818@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> Should that really be TASK_INTERRUPTIBLE? I don't see anything obvious
> in the enclosing for(;;) loop that checks for or handles signals...

If it were TASK_UNINTERRUPTIBLE, it would sit there in the D-state when not
doing anything.  I must admit, I thought I was calling daemonize(), but that
seems to have got lost somewhere.

David
