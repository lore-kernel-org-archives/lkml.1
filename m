Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbZIDJgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbZIDJgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZIDJgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:36:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbZIDJgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:36:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090904092211.C57138B12A@magilla.sf.frob.com>
References: <20090904092211.C57138B12A@magilla.sf.frob.com> <20090903160510.GA23638@redhat.com> <30057.1252054051@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 0/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
Date: Fri, 04 Sep 2009 10:34:24 +0100
Message-ID: <30271.1252056864@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> search_binary_handler calls tracehook_report_exec, which calls
> ptrace_notify when PTRACE_O_TRACEEXEC is enabled.

Ah.  Now I see.

David
