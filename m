Return-Path: <linux-kernel-owner+w=401wt.eu-S1751500AbYJSJHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbYJSJHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 05:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYJSJHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 05:07:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYJSJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 05:07:08 -0400
Date: Sun, 19 Oct 2008 05:07:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Martin Michlmayr <tbm@cyrius.com>, Tobias Frost <tobi@coldtobi.de>,
       linux-kernel@vger.kernel.org, debian-arm@lists.debian.org,
       xfs@oss.sgi.com, kernel@wantstofly.org,
       Hiroki KUMAGAI <hiroki.kumagai@toshiba.co.jp>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081019090702.GA1925@infradead.org>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com> <20081019014830.GI31761@disturbed> <48FAA445.9050800@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FAA445.9050800@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 10:06:45PM -0500, Eric Sandeen wrote:
> This is probably the vmap cache aliasing problem that we paid a bit of
> attention to a few months ago, no?

Shouldn't the cachepolicy switch take care of that?  But yes, there
are various problems with I/O on vmap regions with virtually indexed
caches, see:

	http://www.spinics.net/lists/linux-arch/msg04301.html

	http://tree.celinuxforum.org/CelfPubWiki/JapanTechnicalJamboree21?action=AttachFile&do=get&target=celf_discussions.pdf

Actually, looking again at the second document it shows exactly the
symptoms you're seeing.


> 
> -Eric
> 
> 
---end quoted text---
