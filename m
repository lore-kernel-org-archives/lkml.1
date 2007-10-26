Return-Path: <linux-kernel-owner+w=401wt.eu-S1765974AbXJZWnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765974AbXJZWnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXJZWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:42:51 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46593 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbXJZWmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:42:50 -0400
Date: Fri, 26 Oct 2007 15:42:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Tony Jones <tonyj@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       viro@ftp.linux.org.uk, chrisw@sous-sol.org
Subject: Re: [PATCH] audit: clear thread flag for new children
Message-ID: <20071026224233.GK3660@sequoia.sous-sol.org>
References: <20071026204228.GA1519@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026204228.GA1519@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Jones (tonyj@suse.de) wrote:
> From: Tony Jones <tonyj@suse.de>
> Minor performance enhancement.
> 
> Thread flag TIF_SYSCALL_AUDIT is not cleared for new children when audit 
> context creation has been disabled (auditctl -e0). This can cause new children 
> forked from a parent created when audit was enabled to not take the fastest 
> syscall path thru entry.S
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>

Yeah, I think that's the right thing to do.  Doesn't have an
audit_context anyway.

Acked-by: Chris Wright <chrisw@sous-sol.org>
