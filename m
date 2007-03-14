Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXCNTwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXCNTwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030391AbXCNTwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:52:47 -0400
Received: from verein.lst.de ([213.95.11.210]:55057 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250AbXCNTwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:52:46 -0400
From: Olaf Kirch <okir@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] avoid OPEN_MAX in SCM_MAX_FD
Date: Wed, 14 Mar 2007 20:52:22 +0100
User-Agent: KMail/1.9.1
Cc: Roland McGrath <roland@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <20070314005508.DDC121801C5@magilla.sf.frob.com> <Pine.LNX.4.64.0703131814160.9690@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703131814160.9690@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703142052.24659.okir@lst.de>
X-Spam-Score: -0.6 () BAYES_01
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 02:15, Linus Torvalds wrote:
> Sure. I'm just saying that some people may use OPEN_MAX the way I know
> people use PATH_MAX - whether it's what you're supposed to or not.

glibc removed OPEN_MAX from its header files several years ago. If you
want to find a piece of code that still uses it, it's most likely something
that hasn't seen a compiler in years - and will likely continue to do
so.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
