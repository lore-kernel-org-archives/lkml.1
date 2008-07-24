Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYGXNpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYGXNpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYGXNpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:45:24 -0400
Received: from kruk.ds2.uw.edu.pl ([193.0.110.20]:50912 "EHLO mail.wijata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGXNpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:45:24 -0400
Message-ID: <48888770.70702@wijata.com>
Date: Thu, 24 Jul 2008 15:45:20 +0200
From: "Rafal Wijata (NULL)" <devnull@wijata.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Odd swapping issue
In-Reply-To: <488761F0.4040906@wijata.com>
References: <488761F0.4040906@wijata.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, things are little more clear now I suppose.

I tried (just for fun) echo 8 > /proc/sys/vm/nr_hugepages
and it happened again, and no hugepages were allocated of course.

But this brought the following to my mind.

Since it's nfs server/client, and the nfs is rather heavily utilized(at 
least sometimes), maybe nfsd tasks were unable to find long enough lowmem 
chunk. How can we get such ram? By sweeping pages out to swap, isn't it?

Now the question is, if Linux actually has such feature like blind swapping 
out if lowmem is too fragmented to find requested size?
Can anybody confirm or negate?

Next, I was thinking then I could run 64bit system, but I don't want to 
reinstall it. Anybody knows if it's possible to have installed 32bit OS, but 
run 64bit kernel alone(no 64bit glibc or anything else)?

Thanx in advance.
