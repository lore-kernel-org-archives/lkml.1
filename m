Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbXI0TK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbXI0TK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXI0TKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:10:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56104 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbXI0TKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:10:48 -0400
Date: Thu, 27 Sep 2007 20:10:47 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org
Subject: Re: [RFC][PATCH] kill do_filp_open()
Message-ID: <20070927191047.GA1545@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	miklos@szeredi.hu
References: <20070927190823.A810E243@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927190823.A810E243@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 12:08:23PM -0700, Dave Hansen wrote:
> 
> This kills off the almost empty do_filp_open().  However,
> let's keep filp_open() around.  It does the nameidata allocation
> on the stack, and also adds the AT_FDCWD argument.  I think
> that's enough to keep it around.

So why would we not want to allocate the nameidata in open_namei?

