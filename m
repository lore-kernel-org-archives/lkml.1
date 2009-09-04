Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbZIDIt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbZIDIt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbZIDItZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:49:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbZIDItY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:49:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090903160510.GA23638@redhat.com>
References: <20090903160510.GA23638@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Tom Horsley <tom.horsley@att.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 0/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
Date: Fri, 04 Sep 2009 09:47:31 +0100
Message-ID: <30057.1252054051@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> [PATCH 0/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex

I don't see where it is sleeping in TASK_TRACED with cred_guard_mutex held.

David
