Return-Path: <linux-kernel-owner+w=401wt.eu-S966327AbXDDMdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966327AbXDDMdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966325AbXDDMdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:33:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48703 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992896AbXDDMdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:33:14 -0400
Date: Wed, 4 Apr 2007 13:33:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070404123311.GA18552@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rene Herman <rene.herman@gmail.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <46138B4C.2050409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46138B4C.2050409@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:26:04PM +0200, Rene Herman wrote:
> Hi Rusty.
> 
> Can we have a MODULE_MAINTAINER to complement MODULE_AUTHOR?

#define MODULE_MAINTAINER(x) MODULE_AUTHOR(x), please.
MODULE_AUTHOR really has meant maintainer in practice for ages, and it's
the only actually relevant for users information we should store.
