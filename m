Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYAHUct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYAHUct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbYAHUcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:32:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38519 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYAHUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:32:38 -0500
Date: Tue, 8 Jan 2008 20:32:36 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, proski@gnu.org
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080108203235.GA772@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 09:06:38PM +0200, Pekka Paalanen wrote:
> - Is there anything coming to replace register_page_fault_notifier()?

no.

> - Has someone found another way to accomplish the same without patching
> the kernel?

no.

> - Should I start writing a patch to bring back the notifiers, based on
> the commit that removed them?

no.

> People started to complain to me that mmio-trace does not compile for
> 2.6.24. At least the Nouveau project is a regular user of mmio-trace
> for reverse-engineering, and the tool should be easy to use. Therefore
> I would prefer not to force casual contributors to patch their kernels
> as it might be too much for some. I am hoping that 2.6.25, if not
> 2.6.24, would contain a mechanism to accomplish what I need.

Please make mmio tracing generic enough so it works for every device and
submit it for inclusion as a config option.
