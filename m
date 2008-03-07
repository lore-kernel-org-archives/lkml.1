Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYCGX1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYCGX1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYCGX1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:27:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44697 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYCGX1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:27:16 -0500
Date: Sat, 8 Mar 2008 00:28:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-ID: <20080307232851.GA19757@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <20080307090716.9D3E91B419C@basil.firstfloor.org> <20080307211322.GD7589@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307211322.GD7589@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi, I'm a little confused by _this_ statistics. We could get p = NULL
> there and change MASK_HIGH_WASTE even have mask not allocated. Am I
> wrong or miss something? Or maybe there should be '&&' instead of '||'?

You're right the statistics counter is increased incorrectly for the 
p == NULL case. I'll fix that thanks. || is correct, see the comment
above.

-Andi
