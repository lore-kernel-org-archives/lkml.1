Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXDTHrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXDTHrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbXDTHrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:47:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbXDTHrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:47:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070419160530.1fed265f.akpm@linux-foundation.org> 
References: <20070419160530.1fed265f.akpm@linux-foundation.org>  <11769696211263-git-send-email-ebiederm@xmission.com> <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <29341.1176975158@redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rxrpc: Convert to kthread API. 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 20 Apr 2007 08:47:18 +0100
Message-ID: <832.1177055238@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Do those patches convert all this code over to full use of the kthread
> API?  Because it seems that a conversion would be straightforward, and
> is needed.

No.  They delete all that code entirely and use workqueues instead.  So, I
suppose merging Eric's patches first should be a simple matter of just
deleting his revised code instead.

David
