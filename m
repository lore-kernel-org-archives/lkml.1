Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbXA2KZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbXA2KZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbXA2KZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:25:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39128 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbXA2KZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:25:34 -0500
Date: Mon, 29 Jan 2007 10:25:31 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [PATCH 2/7] lock_list: a fine grain locked double linked list]
Message-ID: <20070129102531.GA26884@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org
References: <1169999597.10987.33.camel@lappy> <20070128172027.GA4913@infradead.org> <1170066040.6189.128.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170066040.6189.128.camel@twins>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:20:40AM +0100, Peter Zijlstra wrote:
> klist is quite different in that it locks the whole list. The proposed
> data structure locks each edge, that is it will allow concurrent
> deletion of elements as long as they don't share neighbours.

Yes, that's one of the reasons why I dislike klist even more ;-) 

