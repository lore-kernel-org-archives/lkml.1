Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYFGVot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYFGVot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbYFGVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:44:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:36201 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbYFGVoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jR3+uYztl1Kyt6u1LEzy63yVk3/FnRJP5zjrtYRQ21QjAE9JU1T7p9T2Lh/EUdBkdv
         t6Gw+Ia+pQamEFaESNiU/pZmf34/UU+sAqNCTX+ItaULi573H4r/PCG+ZOZzYlQK7Tg2
         n/BbcdphVP5iUjBXlyLqGG0cRx+jDmXcixIZg=
Message-ID: <19f34abd0806071444l4b142b00q348ff7a270f40344@mail.gmail.com>
Date: Sat, 7 Jun 2008 23:44:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [mmotm] __build_sched_domains panic
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <484AFC5A.3070006@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484AFC5A.3070006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 11:23 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Hi, Andrew,
>
> I have an x86_64 system with 4 CPUs and 4GB memory and I see the following
> panic, when I boot with fake NUMA nodes. I am still investigating the problem. I
> was trying to use this setup to verify KAMEZAWA's fix for the memcgroup page
> migration problem.

Hi :)

This is already fixed. Actually, it was just caused by a missing patch.

You need a953e4597abd51b74c99e0e3b7074532a60fd031 from the -tip tree.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
