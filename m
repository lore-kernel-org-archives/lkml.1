Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYBLW0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYBLW0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYBLW0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:26:30 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:48823 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYBLW03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:26:29 -0500
Message-ID: <47B21D13.5060700@hp.com>
Date: Tue, 12 Feb 2008 17:26:27 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       npiggin@suse.de, dgc@sgi.com, arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
References: <47B0B69B.1050807@hp.com> <47B218E9.7040405@hp.com>
In-Reply-To: <47B218E9.7040405@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:

> 
> Hopefully, the first column is self-explanatory - these are the settings applied to the queue_affinity, completion_affinity and rq_affinity tunables. Due to the fact that the standard deviations are so large coupled with the very close average results, I'm not seeing anything in this set of tests to favor any of the combinations...
> 

Note quite:

Q or C = 0 really means Q or C set to -1 (default), Q or C = 1 means placing that thread on the CPU managing the IRQ. Sorry... 

<sigh>
Alan
