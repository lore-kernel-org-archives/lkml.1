Return-Path: <linux-kernel-owner+w=401wt.eu-S934762AbXK3ONs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762AbXK3ONs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXK3ONf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:13:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbXK3ONe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:13:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071129225301.21536.91506.stgit@warthog.procyon.org.uk>
References: <20071129225301.21536.91506.stgit@warthog.procyon.org.uk> <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
To: akpm@linux-foundation.org, dwmw2@infradead.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] MN10300: Fix MTD JEDEC probe so that the ASB2303 bootprom can be detected [2.6.24-rc3-mm2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 30 Nov 2007 14:13:21 +0000
Message-ID: <29635.1196432001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

> Fix MTD JEDEC probe so that the ASB2303 bootprom can be accessed.  This is
> presumably required because the bootprom is normally write-protected and so
> the normal flash probes don't work as they require the ability to write to the
> flash to send it commands.
> 
> In the condition of the excluded if-statement, uaddr is 1.

Can you drop this patch please.  The actual error has been found and I believe
DaveW is going to come up with a patch to fix it properly.

David
