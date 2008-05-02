Return-Path: <linux-kernel-owner+w=401wt.eu-S936311AbYEBTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936311AbYEBTH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936729AbYEBTFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:14 -0400
Received: from testure.choralone.org ([194.9.77.134]:59482 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936721AbYEBTFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:12 -0400
Date: Fri, 2 May 2008 15:05:01 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend list debugging to cover hlists
Message-ID: <20080502190501.GA31017@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Matthew Wilcox <matthew@wil.cx>,
	Arjan van de Ven <arjan@infradead.org>,
	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org> <20080502184922.GM14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502184922.GM14976@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 12:49:22PM -0600, Matthew Wilcox wrote:
 > On Thu, May 01, 2008 at 01:32:09PM -0700, Arjan van de Ven wrote:
 > > I like the concept of the patch; however...
 > > BUG() is a tad on the rude side... how about WARN_ON(1) ?
 > 
 > I'm just copying the conventions of the code above.  If those should be
 > WARN_ON(1) then that should be a followup patch.

No objections from me either way.  I chose to BUG originally because
the bug I was chasing was corrupting memory in such a way that we'd
die horribly shortly afterwards anyway.

	Dave

-- 
http://www.codemonkey.org.uk
