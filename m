Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbXEPAOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbXEPAOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758961AbXEPAOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:14:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33303
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757053AbXEPAOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:14:41 -0400
Date: Tue, 15 May 2007 17:14:47 -0700 (PDT)
Message-Id: <20070515.171447.83623268.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: clameter@sgi.com, mroos@linux.ee, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070515165636.5057456e.akpm@linux-foundation.org>
References: <20070515163321.744e2388.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705151642530.3886@schroedinger.engr.sgi.com>
	<20070515165636.5057456e.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 16:56:36 -0700

> On Tue, 15 May 2007 16:45:22 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > KMALLOC_SHIFT_HIGH is not a constant but may be less than 25.
> 
> It darn well better be a compile-time constant.

Try to define a compile-time array size with it smarty
pants :-)

That's what we did initially and it doesn't work.

