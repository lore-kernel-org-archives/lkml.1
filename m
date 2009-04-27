Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZD0Szs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZD0Szs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbZD0Sza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:55:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759686AbZD0Sz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:55:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090427174151.6A284FC3BF@magilla.sf.frob.com>
References: <20090427174151.6A284FC3BF@magilla.sf.frob.com> <20090427161540.16200.23710.stgit@warthog.procyon.org.uk> <20090427161545.16200.54250.stgit@warthog.procyon.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] FRV: utrace: Implement TIF_NOTIFY_RESUME
Date: Mon, 27 Apr 2009 19:54:11 +0100
Message-ID: <21651.1240858451@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> This needs:
> 		tracehook_notify_resume(regs);
> > +	}

Not here, it doesn't.  See patch #4.

David
