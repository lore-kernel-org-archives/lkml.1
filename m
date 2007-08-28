Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbXH1Ux0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbXH1Ux0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbXH1UxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:53:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbXH1UxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:53:17 -0400
Date: Tue, 28 Aug 2007 21:53:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] Linux Kernel Markers - Documentation
Message-ID: <20070828205314.GA10549@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070820202704.927923667@polymtl.ca> <20070820202759.645867202@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820202759.645867202@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 04:27:07PM -0400, Mathieu Desnoyers wrote:
> Here is some documentation explaining what is/how to use the Linux
> Kernel Markers.

While porting my code from an older markers version I noticed the
marker callbacks have grown a void *private argument.  Add it to
the documentation aswell.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/Documentation/marker.txt
===================================================================
--- linux-2.6.orig/Documentation/marker.txt	2007-08-28 22:50:37.000000000 +0200
+++ linux-2.6/Documentation/marker.txt	2007-08-28 22:51:07.000000000 +0200
@@ -115,7 +115,7 @@ struct probe_data {
 };
 
 void probe_subsystem_event(const struct __mark_marker *mdata,
-		const char *format, ...)
+		void *private, const char *format, ...)
 {
 	va_list ap;
 	/* Declare args */
