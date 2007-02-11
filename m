Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbXBKHLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbXBKHLG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 02:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXBKHLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 02:11:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55909 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXBKHLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 02:11:05 -0500
Date: Sun, 11 Feb 2007 07:10:47 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
Message-ID: <20070211071047.GA3847@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ftp.linux.org.uk>, Tejun Heo <htejun@gmail.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com> <20070211063431.GS10050@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211063431.GS10050@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 06:34:31AM +0000, Al Viro wrote:
> +config NO_IOPORT
> +	bool
> +	default n

please make this IOPORT.  config symbols with an implicit negation
are quite horrible for the brain to understand.


