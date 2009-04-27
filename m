Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZD0IuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZD0IuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZD0IuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:50:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46314 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZD0IuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:50:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090426234134.GA13391@redhat.com>
References: <20090426234134.GA13391@redhat.com> <20090425172524.GA3432@redhat.com> <20090424163949.GA12035@redhat.com> <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com> <31842.1240656853@redhat.com> <394.1240686417@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Hugh Dickins <hugh@veritas.com>,
       stable@kernel.org
Subject: Re: [PATCH] ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex
Date: Mon, 27 Apr 2009 09:47:22 +0100
Message-ID: <2414.1240822042@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> ptrace_attach() needs task->cred_exec_mutex, not current->cred_exec_mutex.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
