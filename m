Return-Path: <linux-kernel-owner+w=401wt.eu-S936716AbYBVBDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936716AbYBVBDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYBVBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:02:58 -0500
Received: from c60.cesmail.net ([216.154.195.49]:2982 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYBVBC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:02:56 -0500
Subject: ndiswrapper tainting
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org
Cc: Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 20:02:55 -0500
Message-Id: <1203642175.14339.17.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

What are the chances that incorrect tainting of ndiswrapper will be
fixed in 2.6.25?  I'm worried that it still hasn't happened in the
mainline repository.  It's unfortunate to see that a long discussion
didn't result in a simple fix.  If anyone is waiting for my patch,
please let me know what kind of patch I'm supposed to submit and to
which address.

If the problem is not fixed in 2.6.25, the ndiswrapper module will need
to be renamed in the next release, because otherwise the problem with
unresolved symbols will quickly become the number one in the FAQ.  But
this is undesirable because it would break existing modprobe
configuration files that bind ndiswrapper to specific devices.

Please let's not turn it into another empty discussion.

I represent only myself and I'm not a lawyer.

-- 
Regards,
Pavel Roskin
