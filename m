Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbXD0OZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbXD0OZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXD0OZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:25:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbXD0OZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:25:07 -0400
Date: Fri, 27 Apr 2007 15:25:06 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 18/38] Improved oops output.
Message-ID: <20070427142506.GA12738@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com> <20070427140516.013904506@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427140516.013904506@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:05:21PM +0200, Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> This patch adds two improvements to the oops output. First it adds an
> additional line after the PSW which decodes the different fields of it.
> Second a disassembler is added that decodes the instructions surrounding
> the faulting PSW. The output of a test oops now looks like this:

So we're growing in-kernel disassemblers now? :)

I wonder whether this is really worth it, but at least your handwritten
one is much nicer than the copy & paste from gdb in the kdb patches.
