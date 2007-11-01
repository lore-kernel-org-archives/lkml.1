Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbXKABAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbXKABAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXKABAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:00:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42433
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbXKABAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:00:08 -0400
Date: Wed, 31 Oct 2007 18:00:07 -0700 (PDT)
Message-Id: <20071031.180007.86834938.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710311752380.25515@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710311730280.25414@schroedinger.engr.sgi.com>
	<20071031.175124.84905325.davem@davemloft.net>
	<Pine.LNX.4.64.0710311752380.25515@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 31 Oct 2007 17:53:23 -0700 (PDT)

> > This patch fixes build failures with DEBUG_VM disabled.
> 
> Well there is more there. Last minute mods sigh. With DEBUG_VM you likely 
> need this patch.

Without DEBUG_VM I get a loop of crashes shortly after SSHD
is started, I'll try to track it down.
