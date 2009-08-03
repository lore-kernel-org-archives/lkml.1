Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZHCScb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZHCScb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZHCScb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:32:31 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46257 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZHCSca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:32:30 -0400
Date: Mon, 3 Aug 2009 11:32:25 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] venet: add scatter-gather/GSO support
Message-ID: <20090803113225.4cd414ec@nehalam>
In-Reply-To: <20090803171807.17268.49836.stgit@dev.haskins.net>
References: <20090803171030.17268.26962.stgit@dev.haskins.net>
	<20090803171807.17268.49836.stgit@dev.haskins.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Aug 2009 13:18:07 -0400
Gregory Haskins <ghaskins@novell.com> wrote:

> SG/GSO significantly enhance the performance of network traffic under
> certain circumstances.  We implement this feature as a separate patch
> to avoid intially complicating the baseline venet driver.  This will
> presumably make the review process slightly easier, since we can
> focus on the basic interface first.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

Never mind, previous comment about adding TSO.  But it still would
be good to have ethtool interface for this.

-- 
