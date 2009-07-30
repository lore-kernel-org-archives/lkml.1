Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbZG3VJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbZG3VJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZG3VJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:09:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZG3VJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:09:48 -0400
Date: Thu, 30 Jul 2009 17:09:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: [Patch RFC 20/37] cifs: convert semaphore to mutex
Message-ID: <20090730210946.GA14722@infradead.org>
References: <20090726081459.455111897@linutronix.de> <20090726081555.873287270@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090726081555.873287270@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 08:18:39AM -0000, Thomas Gleixner wrote:
> -	struct semaphore sesSem;
> +	struct mutex sesSem;

If we touch every user of this anyway any chance we could give it a sane
name, e.g. session_mutex?

