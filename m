Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYHST1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYHST1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYHST1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:27:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49839 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYHST1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:27:30 -0400
Message-ID: <48AB1DE2.30402@cs.helsinki.fi>
Date: Tue, 19 Aug 2008 22:24:18 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com
Subject: Re: [PATCH 2/5] kmemtrace: Better alternative to "kmemtrace: fix
 printk format warnings".
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro>
In-Reply-To: <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> Fix the problem "kmemtrace: fix printk format warnings" attempted to fix,
> but resulted in marker-probe format mismatch warnings. Instead of carrying
> size_t into probes, we get rid of it by casting to unsigned long, just as
> we did with gfp_t.
> 
> This way, we don't need to change marker format strings and we don't have
> to rely on other format specifiers like "%zu", making for consistent use
> of more generic data types (since there are no format specifiers for
> gfp_t, for example).
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Applied, thanks!
