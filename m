Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYG1Ixe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYG1Ixe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYG1IxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:53:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbYG1IxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:53:24 -0400
Date: Mon, 28 Jul 2008 01:53:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2][-mm][resend] memcg limit change shrink usage.
Message-Id: <20080728015313.b4628537.akpm@linux-foundation.org>
In-Reply-To: <11498528.1217234602331.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080722014517.04e88306.akpm@linux-foundation.org>
	<20080714171154.e1cc9943.kamezawa.hiroyu@jp.fujitsu.com>
	<20080714171522.d1cd50e9.kamezawa.hiroyu@jp.fujitsu.com>
	<11498528.1217234602331.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 17:43:22 +0900 (JST) kamezawa.hiroyu@jp.fujitsu.com wrote:

> >Guys, this is core Linux kernel, not some weekend hack project.  Please
> >work to make it as comprehensible and as maintainable as we possibly
> >can.
> >
> >Also, it is frequently a mistake for a callee to assume that the caller
> >can use GFP_KERNEL.  Often when we do this we end having to change the
> >interface so that the caller passes in the gfp_t.  As there's only one
> >caller I guess we can get away with it this time.  For now.
> >
> 
> Hmm, ok. will rework this and take gfp_t as an argument.

I don't think it's necessary, really.  I was just talking to myself ;)
