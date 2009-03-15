Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZCOGUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZCOGUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZCOGUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:20:46 -0400
Received: from kuber.nabble.com ([216.139.236.158]:57097 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZCOGUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:20:46 -0400
Message-ID: <22520422.post@talk.nabble.com>
Date: Sat, 14 Mar 2009 23:20:43 -0700 (PDT)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: COW optimization on exec
In-Reply-To: <200903151458.25363.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <22519639.post@talk.nabble.com> <200903151458.25363.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> exec throws out all those pages, so go away without ever having been
> copied. However it still costs memory CPU time TLB flushes etc in order
> to set up the COW optimisation in the first place, so if you are doing
> fork/exec, then I think vfork is the better option.


Thanks once again, if I do something like creating an array spanning over
multiple pages, and then do a fork and in the child or the parent, write to
the array elements, this should result in an actual cow, where the OS will
actually do a copy of the pages as well in addition to the overhead required
for setting up COW in the first place?

Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



-- 
View this message in context: http://www.nabble.com/COW-optimization-on-exec-tp22519639p22520422.html
Sent from the linux-kernel mailing list archive at Nabble.com.

