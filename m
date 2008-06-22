Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYFVUoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYFVUoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYFVUn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:43:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:18869 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYFVUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KiyMt9JYbYQ/F3HjUJ1cMY88WIN6n0xSRCDBMHHDLdLcGKYzrX5vGrX0Cg4iyshrYF
         fpW+0tQPPTYU+weCJulTtBFS70sWECA38D08LMc9wgKJ3HJez9mqVQG8jmAEEjDp881J
         Iwe541+FrbTrJ3cwuOJU9tf6KXeP4RQ6vz/Jw=
Message-ID: <19f34abd0806221343o3a9e3951j1448e968f9ba9684@mail.gmail.com>
Date: Sun, 22 Jun 2008 22:43:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, tzanussi@gmail.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080622233848.50f14605@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621171051.5ed3b522@linux360.ro>
	 <84144f020806221222s7498593ap7cad427405fb6776@mail.gmail.com>
	 <20080622233848.50f14605@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 10:38 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> Will do, good idea. However, I feel like these should be two different
> patches. The first adds the new interface, the second converts existing
> users to the new interface. Will resubmit the patch series soon, along
> with the conversion patch.

By the way -- may I ask why it is called early_initcall() and not
pre_smp_initcall()? I think it makes sense to encode the exact purpose
of the initcall into the name. "early" is not very explicit. This is
just my opinion :-) Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
