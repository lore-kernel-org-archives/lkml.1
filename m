Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbXELAGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbXELAGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXELAGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:06:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55383
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbXELAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:06:34 -0400
Date: Fri, 11 May 2007 17:06:38 -0700 (PDT)
Message-Id: <20070511.170638.35663266.davem@davemloft.net>
To: mark@glines.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070511170135.7c38615f@chirp>
References: <20070511170135.7c38615f@chirp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Glines <mark@glines.org>
Date: Fri, 11 May 2007 17:01:35 -0700

> Following the principle of least astonishment, I think it seems better
> to use high, out-of-the-way port numbers regardless of how much RAM the
> system has.  So, the following patch changes this behavior slightly.
> The system still picks a dynamic range depending on the bind hash size,
> but now, all ranges start with 32768.  I suppose another reasonable way
> to do this would be to end all ranges with 61000, or something like
> that.

All ports above and including 1024 are non-privileged and available to
anyone.

Applications which have some requirements in this area need to work
those things out themselves.
