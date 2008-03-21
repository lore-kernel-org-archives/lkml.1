Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYCUHb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYCUHb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYCUHbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:31:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40679
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753898AbYCUHbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:31:11 -0400
Date: Fri, 21 Mar 2008 00:31:23 -0700 (PDT)
Message-Id: <20080321.003123.180348056.davem@davemloft.net>
To: clameter@sgi.com
Cc: dada1@cosmosbay.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [14/14] vcompound: Avoid vmalloc for ehash_locks
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803210002450.15903@schroedinger.engr.sgi.com>
References: <20080321061727.491610308@sgi.com>
	<47E35D73.6060703@cosmosbay.com>
	<Pine.LNX.4.64.0803210002450.15903@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 21 Mar 2008 00:03:51 -0700 (PDT)

> On Fri, 21 Mar 2008, Eric Dumazet wrote:
> 
> > But, isnt it defeating the purpose of this *particular* vmalloc() use ?
> 
> I thought that was controlled by hashdist? I did not see it used here and 
> so I assumed that the RR was not intended here.

It's intended for all of the major networking hash tables.
