Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYC1UeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYC1UeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYC1UeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:34:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50998 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255AbYC1UeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:34:04 -0400
Date: Fri, 28 Mar 2008 21:34:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: use of volatile in iounmap()?
Message-ID: <20080328203427.GA14256@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reviewing some CAN driver I stumbled on iounmap
which has following prototype on x86:

extern void iounmap(volatile void __iomem *addr);

I argued that the driver should not use volatile
but then I cannot explain why the argument to
iounmap takes a volatile.

The same goes for many other functions in
the io*.h headers.

Grepping the other archs they mostly follow
same pattern.

Can anyone explain the rational for volatile in this case.

Thanks,
	Sam
