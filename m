Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXEPNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXEPNZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbXEPNZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:25:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948AbXEPNZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:25:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1179317360.2859.225.camel@shinybook.infradead.org>
References: <1179317360.2859.225.camel@shinybook.infradead.org> <20070318233008.GA32597093@melbourne.sgi.com> <18993.1179310769@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 14:25:04 +0100
Message-ID: <17317.1179321904@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> Really? Is it _really_ going to be modified?

Well, generic_file_buffered_write() doesn't check the success of the copy
before calling commit_write(), presumably because it uses
fault_in_pages_readable() first.

David
