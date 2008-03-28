Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYC1KMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYC1KMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYC1KMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:12:24 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:6417 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbYC1KMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:12:23 -0400
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, rjw@sisk.pl, akpm@linux-foundation.org,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       marcus@better.se, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080327.175939.165029213.davem@davemloft.net>
References: <20080327222248.GA3596@ami.dom.local>
	 <20080327.152218.235944668.davem@davemloft.net>
	 <20080327223913.GB3596@ami.dom.local>
	 <20080327.175939.165029213.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 11:12:11 +0100
Message-Id: <1206699131.8514.612.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 17:59 -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Thu, 27 Mar 2008 23:39:13 +0100
> 
> > On Thu, Mar 27, 2008 at 03:22:18PM -0700, David Miller wrote:
> > ...
> > > Instead of going back and forth like this can someone post
> > > just take it upon themselves to post such an obvious patch
> > > already :-)
> > > 
> > > All of this "he'll do it, she'll do it" just wastes time.
> > 
> > Right! She or he should also remember to add Peter's lockup
> > scenario and his signed-off-by...
> 
> I didn't put in a Signed-off-by since Peter didn't give
> one, but I did give him credit for the discovery and I
> did list explicitly his given logic.

Hehe, nr_emails > loc_changed situation alert!

Fwiw here's my ACK:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

