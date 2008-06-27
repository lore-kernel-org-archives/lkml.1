Return-Path: <linux-kernel-owner+w=401wt.eu-S932575AbYF0XOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbYF0XOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765560AbYF0XFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:05:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765539AbYF0XFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:05:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <486357EC.5060205@kernel.org>
References: <486357EC.5060205@kernel.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] security: filesystem capabilities bugfix2
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sat, 28 Jun 2008 00:04:13 +0100
Message-ID: <21854.1214607853@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew G. Morgan <morgan@kernel.org> wrote:

> +static inline int cap_limit_straced_target(void) { return 1; }

Calling it cap_limit_ptraced_target() would probably be better.

David
