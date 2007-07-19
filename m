Return-Path: <linux-kernel-owner+w=401wt.eu-S964956AbXGSONN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956AbXGSONN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938030AbXGSOCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:02:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44220 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938817AbXGSOCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:02:30 -0400
Date: Thu, 19 Jul 2007 15:02:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       hch@infradead.org, devel@openvz.org
Subject: Re: [PATCH] Consolidate PTRACE_DETACH
Message-ID: <20070719140226.GC16279@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	devel@openvz.org
References: <20070719123800.GA31240@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719123800.GA31240@localhost.sw.ru>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 04:38:01PM +0400, Alexey Dobriyan wrote:
> Identical handlers of PTRACE_DETACH go into ptrace_request().
> Not touching compat code.
> Not touching archs that don't call ptrace_request.

Looks very nice, thanks.
