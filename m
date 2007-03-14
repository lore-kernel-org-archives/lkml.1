Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbXCNCWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbXCNCWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 22:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbXCNCWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 22:22:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57281
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933796AbXCNCWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 22:22:38 -0400
Date: Tue, 13 Mar 2007 19:22:37 -0700 (PDT)
Message-Id: <20070313.192237.112853631.davem@davemloft.net>
To: samuel@sortiz.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: irda rmmod lockdep trace.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070314005003.GA15151@sortiz.org>
References: <20070312003843.GA3394@sortiz.org>
	<20070312.164921.71090866.davem@davemloft.net>
	<20070314005003.GA15151@sortiz.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <samuel@sortiz.org>
Date: Wed, 14 Mar 2007 02:50:03 +0200

> On Mon, Mar 12, 2007 at 04:49:21PM -0700, David Miller wrote:
> > I would strongly caution against adding any run-time overhead just to
> > cure a false lockdep warning.  Even adding a new function argument
> > is too much IMHO.
> > 
> > Make the cost show up for lockdep only, perhaps by putting each
> > hashbin lock into a seperate locking class?
> Does that look better to you:

Yes, it does.:)
