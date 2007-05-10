Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbXEJPxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbXEJPxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXEJPxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:53:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51642 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbXEJPxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:53:22 -0400
Date: Thu, 10 May 2007 16:53:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: pte_{ex,rd}protect
Message-ID: <20070510155321.GB27834@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
	discuss@x86-64.org
References: <46430780.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46430780.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:52:32AM +0200, Jan Beulich wrote:
> Various architectures define these, but they aren't being used anywhere -
> candidates for removal? The more that (at least) on i386 and x86-64
> pte_exprotect() is not symmetrical to pte_exec() and pte_mkexec()...

Yeah, just kill them.

