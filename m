Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbXEaN7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbXEaN7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXEaN7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:59:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37331 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbXEaN73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:59:29 -0400
Date: Thu, 31 May 2007 14:59:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-ID: <20070531135928.GB30501@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070425154934.GP6798@traven> <20070425191359.GA13241@infradead.org> <20070425194633.GA3280@traven> <20070425194550.GA18914@infradead.org> <20070531134226.GO14284@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531134226.GO14284@traven>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 03:42:26PM +0200, Matthias Kaehlcke wrote:
> drivers/char/tty_io.c: Use spinlock instead of a (binary) semaphore

Looks good.
