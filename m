Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZFWRto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZFWRto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZFWRth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:49:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZFWRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:49:37 -0400
Date: Tue, 23 Jun 2009 13:49:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: security: rename ptrace_may_access => ptrace_access_check
Message-ID: <20090623174918.GA24430@infradead.org>
References: <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org> <20090623141451.GA8133@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623141451.GA8133@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Umm, I think I mentioned it before:  if you really need to rename that
beast please kill the ptrace part as we use it for all kinds of other
things.

