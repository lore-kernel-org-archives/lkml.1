Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXCLLXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXCLLXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965652AbXCLLXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:23:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43810
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965646AbXCLLX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:23:28 -0400
Date: Mon, 12 Mar 2007 04:23:26 -0700 (PDT)
Message-Id: <20070312.042326.59467679.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, ak@suse.com, holt@sgi.com,
       linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703120409150.25910@schroedinger.engr.sgi.com>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com>
	<20070311.135946.28788670.davem@davemloft.net>
	<Pine.LNX.4.64.0703120409150.25910@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Mon, 12 Mar 2007 04:12:32 -0700 (PDT)

> On Sun, 11 Mar 2007, David Miller wrote:
> 
> > I'm going to make the radical declaration that it be perhaps often
> > better to always initialize page table chunks to all zeros on
> > allocation.
> 
> That is the case if most of the page is going to be used soon. If we have 
> sparse access patterns then not zeroing can avoid uselessly bringing 
> cachelines in.

Good point.
