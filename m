Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbXFDMgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbXFDMgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbXFDMgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:36:24 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59875 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXFDMgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:36:23 -0400
Date: Mon, 4 Jun 2007 14:33:05 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Adrian Bunk <bunk@stusta.de>
cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH] Fix roundup_pow_of_two(1)
In-Reply-To: <20070604114900.GS5500@stusta.de>
Message-ID: <Pine.LNX.4.64.0706041431310.29896@twin.jikos.cz>
References: <200705172356.57620.eike-kernel@sf-tec.de> <20070604114900.GS5500@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Adrian Bunk wrote:

> > 1 is a power of two, therefore roundup_pow_of_two(1) should return 1. It does
> > in case the argument is a variable but in case it's a constant it behaves
> > wrong and returns 0. Probably nobody ever did it so this was never noticed.
> I'm not getting the problem.
> 2^0 = 1

Adrian,

that's of course true, but unrelated to the patch in question :)

You simply want roundup_pow_of_two(1) to be 1, and not 0. That's what the 
patch does, and that's correct.

-- 
Jiri Kosina
