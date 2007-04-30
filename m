Return-Path: <linux-kernel-owner+w=401wt.eu-S1423186AbXD3JMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423186AbXD3JMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423187AbXD3JMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:12:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51782 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423186AbXD3JMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:12:47 -0400
Date: Mon, 30 Apr 2007 10:12:44 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utrace: remove exports
Message-ID: <20070430091244.GA949@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
	akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20070418180113.GA18485@lst.de> <20070430040232.EB3DD1801A4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430040232.EB3DD1801A4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:02:32PM -0700, Roland McGrath wrote:
> > EXPORT_SYMBOL_GPL(utrace_attach);
> > 
> > 	There is not modular user of this, so this and the other utrace_
> > 	functions should not be exported.  Nor do I think that exporting
> > 	such a low-level process control is nessecary a good idea, but
> > 	we'll have to evaluate that if patches to add users show up.
> 
> If you remove the exports, just throw the whole thing away.
> The reason utrace exists is to be used by modules.

used != used by modules.  Even without things exported you can use
things in the kernel.  Once we have a valid modular use case we can
add exports.

