Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZDYTI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZDYTI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 15:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZDYTIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 15:08:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46396 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbZDYTIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 15:08:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090425172524.GA3432@redhat.com>
References: <20090425172524.GA3432@redhat.com> <20090424163949.GA12035@redhat.com> <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com> <31842.1240656853@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Hugh Dickins <hugh@veritas.com>
Subject: Re: ptrace && cred_exec_mutex (Was: [PATCH] ptrace: tracehook_unsafe_exec: remove the stale comment)
Date: Sat, 25 Apr 2009 20:06:57 +0100
Message-ID: <394.1240686417@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Unless I missed something, ptrace_attach() should take task->cred_exec_mutex.

Bah!  Yes.

David
