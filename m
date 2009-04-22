Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZDVVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZDVVAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZDVVAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:00:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45347 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753648AbZDVVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:00:08 -0400
Date: Wed, 22 Apr 2009 21:59:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       mark.langsdorf@amd.com, arekm@maven.pl,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090422215913.67c1298e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090422202453.829846363@polymtl.ca>
References: <20090422201852.092307236@polymtl.ca>
	<20090422202453.829846363@polymtl.ca>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no official AMD bug ID yet, but it seems to be reported in the field
> and a fix is present in Solaris code base. The following links shows the current
> understanding of the issue.

I would like to know why there isn't an official vendor Bug ID yet
because without that nobody knows what the fix actually is or when it is
needed. It's also not going to help much given the user space problem
(and mixed kernel/user stuff like futexes).

Second point - it needs to be possible to avoid compiling this stuff in
the first place. I don't see where you arrange CMPXCHNG_LFENCE to come
out as blank when people compile for processors without the bug ?

