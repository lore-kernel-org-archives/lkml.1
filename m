Return-Path: <linux-kernel-owner+w=401wt.eu-S1762211AbXH3PPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211AbXH3PPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbXH3PPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:15:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760043AbXH3PPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:15:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200708301701.36533.agruen@suse.de>
References: <200708301701.36533.agruen@suse.de> <20070808171622.632749741@suse.de> <20070810143846.930027497@suse.de> <20070829190823.GB28028@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [FIX] mntput called before dput in afs
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 30 Aug 2007 16:15:26 +0100
Message-ID: <10812.1188486926@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher <agruen@suse.de> wrote:

> dput must be called before mntput here. Please consider for 2.6.24 and stable.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Fine by me.

Acked-By: David Howells <dhowells@redhat.com>
