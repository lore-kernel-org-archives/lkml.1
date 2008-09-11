Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYIKV7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYIKV7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYIKV7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:59:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38585
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYIKV7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:59:43 -0400
Date: Thu, 11 Sep 2008 14:59:37 -0700 (PDT)
Message-Id: <20080911.145937.178601244.davem@davemloft.net>
To: elad_lahav@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initial support for Niagara T1 performance counters
From: David Miller <davem@davemloft.net>
In-Reply-To: <48C98820.3080009@users.sourceforge.net>
References: <48C98820.3080009@users.sourceforge.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elad Lahav <elad_lahav@users.sourceforge.net>
Date: Thu, 11 Sep 2008 17:05:36 -0400

> The patch handles performance counter overflow traps, which are
> currently being ignored.

Full support for both T1 and T2 performance counters (as well as those
of all other sparc64 processors) is contained in the perfmon2 tree.

Those patches handle the overflow conditions and everything else.

There is no reason to put short term hacks like this on into the tree,
meanwhile.
