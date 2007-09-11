Return-Path: <linux-kernel-owner+w=401wt.eu-S965982AbXIKKLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965982AbXIKKLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbXIKKKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:10:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbXIKKKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:10:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070911093510.GA15405@kernel.dk>
References: <20070911093510.GA15405@kernel.dk> <20070911082307.GB19495@linux-sh.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dhowells@redhat.com, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] splice: Disable vmsplice on nommu.
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 11 Sep 2007 11:10:19 +0100
Message-ID: <9949.1189505419@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:

> It's a bit of a sledge hammer... Since get_user_pages() appears to work
> on nummu, we can just disable the vmsplice-to-userspace bits and leave
> the (working) vmsplice-from-userspace in place.

That sounds about right.  I don't think you can do the latter without an MMU,
but I may be wrong about what it does.

David
