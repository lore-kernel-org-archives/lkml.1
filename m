Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYKKAUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYKKAUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYKKAUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:20:12 -0500
Received: from smtprelay05.ispgateway.de ([80.67.18.43]:46973 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbYKKAUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:20:10 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
Date: Tue, 11 Nov 2008 01:20:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; x86_64; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Frank Mayhar <fmayhar@google.com>, Doug Chapman <doug.chapman@hp.com>,
       mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1224694989.8431.23.camel@oberon> <Pine.LNX.4.64.0811100834500.21257@quilx.com> <1226328152.7685.192.camel@twins>
In-Reply-To: <1226328152.7685.192.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811110120.04768.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2008, Peter Zijlstra wrote:
> The detail I've not looked at is, if when this itimer is indeed active
> and we are running 256 threads of the same application on all cpus do we
> then do the per-cpu loop for each tick on each cpu?

Can't this kind of aggregation not be done in a tree-like manner?

I mean these CPUs are not on the same node, right?


Best Regards

Ingo Oeser
