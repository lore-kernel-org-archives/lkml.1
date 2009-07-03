Return-Path: <linux-kernel-owner+w=401wt.eu-S1751215AbZGCEDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbZGCEDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 00:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZGCEDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 00:03:47 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:55846 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZGCEDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 00:03:46 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] integrity: add ima_counts_put (updated) 
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1246313060.3280.81.camel@dyn9002018117.watson.ibm.com>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com> <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com> <12000.1246284749@jrobl> <1246286783.4054.56.camel@dyn9002018117.watson.ibm.com> <7959.1246307789@jrobl> <1246313060.3280.81.camel@dyn9002018117.watson.ibm.com>
Date: Fri, 03 Jul 2009 13:02:41 +0900
Message-ID: <7465.1246593761@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> NFSv3 is an interesting example. Permission checking is done once,
> followed by multiple open/read/close calls. Incrementing the counters in
> nfsd_permission() once and decrementing the counters in close, multiple
> times, resulted in imbalance messages.  True, the solution in this case
> was to increment in open and decrement in close, but that was only part
> of the solution.  The other part of the solution, the important part,
> was to add a call to ima_path_check() to measure the file.

Let me make sure.
Does "that was only part of the solution" mean IMA does not work for
NFSD fully? To make IMA work fully, is incrementing before open
absolutely necessary?


J. R. Okajima
