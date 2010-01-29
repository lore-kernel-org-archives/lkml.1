Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851Ab0A2W3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0A2W3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874Ab0A2W3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:29:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab0A2W3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:29:09 -0500
Date: Fri, 29 Jan 2010 17:29:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: Re: [patch 05/10] cifs: convert semaphore to mutex
Message-ID: <20100129222905.GA18752@infradead.org>
References: <20100129203549.526478432@linutronix.de> <20100129203613.554147570@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129203613.554147570@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:38:50PM -0000, Thomas Gleixner wrote:
> pSesInfo->sesSem is used as mutex. Rename it to session_mutex and
> convert it to a real mutex.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Steve French <sfrench@us.ibm.com>

Looks good, but I'm pretty sure I've seen an equivalent patch on the
linux-cifs-client list before.


Reviewed-by: Christoph Hellwig <hch@lst.de>

