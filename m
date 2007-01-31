Return-Path: <linux-kernel-owner+w=401wt.eu-S933292AbXAaOUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbXAaOUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933294AbXAaOUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:20:37 -0500
Received: from verein.lst.de ([213.95.11.210]:40633 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292AbXAaOUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:20:36 -0500
Date: Wed, 31 Jan 2007 15:20:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@lst.de, alan@redhat.com
Subject: Re: [PATCH] tty: cleanup release_mem
Message-ID: <20070131142019.GA23251@lst.de>
References: <Pine.LNX.4.64.0701310915380.4390@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701310915380.4390@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -4.901 () BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.  I'd have only kept a pointer to the struct module,
but that shouldn't matter for the actual code generated.
