Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZIUX46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZIUX46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZIUX44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:56:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:56004 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbZIUX4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:56:55 -0400
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Tejun Heo <tj@kernel.org>, Sachin Sant <sachinp@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090921135733.GP12726@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
	 <1253302451-27740-2-git-send-email-mel@csn.ul.ie>
	 <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com>
	 <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi>
	 <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com>
	 <20090921084248.GC12726@csn.ul.ie> <20090921130440.GN12726@csn.ul.ie>
	 <4AB78385.6020900@kernel.org>  <20090921135733.GP12726@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 09:54:21 +1000
Message-Id: <1253577261.7103.169.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 14:57 +0100, Mel Gorman wrote:
> Sachin should be enjoying his holiday and I'm hogging his machine at
> the
> moment.  However, I can report that with this patch applied as well as
> the
> remote-free patch that the machine locks up after a random amount of
> time
> has passed and doesn't respond to sysrq. Setting
> CONFIG_RCU_CPU_STALL_DETECTOR=y didn't help throw up an error. Will
> enable a few other debug options related to stall detection and see
> does
> it pop out.

You can also throw it into xmon (provided you have it enabled) using the
"dump restart" command from the HMC. This does the equivalent of an NMI.

Cheers,
Ben.



