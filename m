Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYFWR1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYFWR1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYFWR1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:27:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:56823 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYFWR1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ElGfiDYBpeH6f7Zd27RBj4HBRYjyhD0TOQg7N8f9qq2QOX7rcr5UgA2N+5h33ynXI7
         /x2ZQ6noGlwLsLMjiLIT2V6E9eD1j8nCNqoBdez+2wN/6eNLM5dJlREULnnK67fXaaat
         hSsjnvMiB1CMLOCaO6rz0RQqyiVAOm+hY9qTQ=
Message-ID: <19f34abd0806231026t1c797c28td50a141b9715bf94@mail.gmail.com>
Date: Mon, 23 Jun 2008 19:26:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Steven Rostedt" <srostedt@redhat.com>
Subject: Re: linux-next: Tree for June 23
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <19f34abd0806230526j77fc20e7w3d92cbe67ad4c552@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080623182549.b0552851.sfr@canb.auug.org.au>
	 <19f34abd0806230323o6373015fj93a85b929545a7a8@mail.gmail.com>
	 <19f34abd0806230326i592ba39eu837d290e21431d14@mail.gmail.com>
	 <19f34abd0806230402x502eca3cna927eb8742553570@mail.gmail.com>
	 <19f34abd0806230526j77fc20e7w3d92cbe67ad4c552@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 2:26 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> And additionally, the next two boots hung here (but the third one was okay):
>
> http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080623-next/DSCF3015.JPG
>
> I don't know what these issues are related too. I can try
> debug_initcall for the hang.

The last initcall to run is populate_rootfs(), however the last
message on the screen is "debug: unmapping init memory
f7cb0000..f7ff0000":

http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080623-next/DSCF3016.JPG

In fact, it seems to me that init memory is being unmapped before all
initcalls have finished... that would seem disastrous.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
