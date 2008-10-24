Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYJXSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYJXSoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYJXSoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:44:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbYJXSoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:44:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081024174838.GA24466@us.ibm.com>
References: <20081024174838.GA24466@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>, jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Date: Fri, 24 Oct 2008 19:44:01 +0100
Message-ID: <11290.1224873841@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> I've just tested with David's plain creds-v3 tree

Note the creds-v4 branch is now current.  Is it worth me replacing that with a
tree that just has a master branch to simplify things?

> -	struct user_namespace *ns = current->nsproxy->user_ns;
> +	struct user_namespace *ns = current_user()->user_ns;

current_user_ns() perchance?

Looks
