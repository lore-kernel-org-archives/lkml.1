Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZLAPi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZLAPi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZLAPi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:38:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZLAPiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:38:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091130224032.GA5598@x200.malnet.ru>
References: <20091130224032.GA5598@x200.malnet.ru>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, jkj@kapsi.fi,
       linux-kernel@vger.kernel.org, mschmidt@redhat.com, serue@us.ibm.com,
       jmorris@namei.org
Subject: Re: [PATCH] bsdacct: fix uid/gid misreporting (#14676)
Date: Tue, 01 Dec 2009 15:38:09 +0000
Message-ID: <6979.1259681889@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:

> commit d8e180dcd5bbbab9cd3ff2e779efcf70692ef541
> "bsdacct: switch credentials for writing to the accounting file"
> introduced credential switching during final acct data collecting.
> However, uid/gid pair continued to be collected from current which
> became credentials of who created acct file, not who exits.
> 
> Fix http://bugzilla.kernel.org/show_bug.cgi?id=14676
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
