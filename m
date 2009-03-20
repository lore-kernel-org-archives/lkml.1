Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZCTTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZCTTCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZCTTCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:02:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38715 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZCTTCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:02:04 -0400
To: cl@linux-foundation.org, nitingupta910@gmail.com
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <alpine.DEB.1.10.0903201337500.18010@qirst.com>
Message-ID: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Fri, 20 Mar 2009 21:01:59 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/20/2009, "Christoph Lameter" <cl@linux-foundation.org> wrote:
> > I think, with a bit playing around with interfaces, it can be turned into
> > general purpose allocator (this will most probably lack highmem support).
> 
> Then it would need to implement the SLAB api (see include/linux/slab.h).
> Thus we are getting slab allocator #5.

I do not see the point in that. As I suggested earlier, you should
probably just move this into drivers/block/ and make it a private
compcache allocator.
