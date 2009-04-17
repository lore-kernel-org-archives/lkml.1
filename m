Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbZDQGso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbZDQGso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbZDQGse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:48:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44491 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZDQGsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:48:33 -0400
Date: Fri, 17 Apr 2009 02:48:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mathieu.desnoyers@polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/4] tracing: pass proto and args to DEFINE_TRACE
Message-ID: <20090417064820.GA20685@infradead.org>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-4-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239950139-1119-4-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 11:35:38PM -0700, Jeremy Fitzhardinge wrote:
> -DEFINE_TRACE(power_mark);
> +DEFINE_TRACE(power_mark,
> +	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
> +	      TP_ARGS(it, type, state));

Wrong indentation, the TP_ARGS should have the same level of indentation
(one) as the TP_PROTO.  Also true for all others.

