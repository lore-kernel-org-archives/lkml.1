Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYJUPkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYJUPkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYJUPki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:40:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53346 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYJUPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:40:37 -0400
Date: Tue, 21 Oct 2008 08:39:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Iwo Mergler <iwo@call-direct.com.au>
Cc: linux-kernel@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: Fix for genalloc locking
Message-Id: <20081021083949.3b1473c8.randy.dunlap@oracle.com>
In-Reply-To: <48F83400.90901@call-direct.com.au>
References: <48F83400.90901@call-direct.com.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 16:43:12 +1000 Iwo Mergler wrote:

> Hi,
> 
> I hit a little problem while using genalloc with a mix
> of interrupt/non-interrupt context. I believe the correct
> fix is to replace the locking calls with the _irqsave/_irqrestore
> variants. Patch follows.
> 
> Is this correct?
> 
> BTW, is there any documentation on the Lockdep warnings?
> What exactly is the meaning of {--+.} in 
> 
> (&pool->lock){--+.}, at: [<c0125d1c>] gen_pool_free+0x34/0x120

Did you read Documentation/lockdep-design.txt ?

---
~Randy
