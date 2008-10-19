Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbYJSQW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbYJSQW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 12:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYJSQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 12:22:49 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:44894 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYJSQWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 12:22:48 -0400
Date: Sun, 19 Oct 2008 18:22:44 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Martin Michlmayr <tbm@cyrius.com>,
       Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com,
       Hiroki KUMAGAI <hiroki.kumagai@toshiba.co.jp>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081019162244.GF4129@xi.wantstofly.org>
References: <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com> <20081019014830.GI31761@disturbed> <48FAA445.9050800@sandeen.net> <20081019090702.GA1925@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019090702.GA1925@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 05:07:02AM -0400, Christoph Hellwig wrote:

> > This is probably the vmap cache aliasing problem that we paid a bit of
> > attention to a few months ago, no?
> 
> Shouldn't the cachepolicy switch take care of that?

Setting cachepolicy=uncached should make aliasing issues disappear.
If you're still seeing issues with cachepolicy=uncached, it's likely
some other issue.
