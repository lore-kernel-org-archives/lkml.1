Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYJETgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYJETgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbYJETf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:35:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:63828 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbYJETf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p7xqNrBkcRgjnPW7Hp4SoW42/QSsKmLOkcxLGedtoKOb7Lp9ZeNRssSxEma1HFFxT7
         sEUOw6fk3Z74BqAj5fYDtw+JOPf2cdyRfQXSvi+kPnWV1Pr5XumpM5mb6I9cIYxAyZcV
         SvddEoxadvRQVt9+YhyjAG3Qyqb0dKlcllKwI=
Message-ID: <19f34abd0810051235u7f21da03q324d3d0bbe110075@mail.gmail.com>
Date: Sun, 5 Oct 2008 21:35:57 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 3/4] x86: corruption check: run the corruption checks from a work queue
Cc: mingo@elte.hu, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081005120903.2dc262f4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081005120705.02492d44@infradead.org>
	 <20081005120903.2dc262f4@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2008 at 9:09 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 22 Sep 2008 13:42:15 -0700
> Subject: [PATCH] x86: corruption check: run the corruption checks from a work queue
>
> the periodic corruption checks are better off run from a work queue; there's
> nothing time critical about them and this way the amount of
> interrupt-context work is reduced.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Hi,

Did you figure out what's causing these corruptions yet?

Can't you do so by simply reserving the memory area in question,
clearing the present bit for those pages, and letting the page fault
handler catch whatever code is accessing it?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
