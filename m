Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYCNL7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYCNL7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYCNL6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:58:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbYCNL6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:58:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] KEYS: Make key_serial() a function if CONFIG_KEYS=y
To: torvalds@osdl.org, akpm@linux-foundation.org, kwc@citi.umich.edu
Cc: arunsr@cse.iitk.ac.in, dwalsh@redhat.com,
       linux-security-module@vger.kernel.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2008 11:58:29 +0000
Message-ID: <20080314115829.19124.65879.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080314115823.19124.76244.stgit@warthog.procyon.org.uk>
References: <20080314115823.19124.76244.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make key_serial() an inline function rather than a macro if CONFIG_KEYS=y.
This prevents double evaluation of the key pointer and also provides better
type checking.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 0 files changed, 0 insertions(+), 0 deletions(-)



