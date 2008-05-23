Return-Path: <linux-kernel-owner+w=401wt.eu-S1765251AbYEWHBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765251AbYEWHBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYEWHBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:01:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbYEWHBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:01:34 -0400
Date: Fri, 23 May 2008 00:01:29 -0700 (PDT)
Message-Id: <20080523.000129.193706282.davem@davemloft.net>
To: tglx@linutronix.de
Cc: jason.wessel@windriver.com, a.beregalov@gmail.com,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: kgdb test suite failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805222304250.3295@apollo.tec.linutronix.de>
References: <a4423d670805201130l649440acl3ef31f60503b279d@mail.gmail.com>
	<48344D5B.1020308@windriver.com>
	<alpine.LFD.1.10.0805222304250.3295@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 22 May 2008 23:14:23 +0200 (CEST)

> Please use HW breakpoints in the test suite. The RFC patch looks
> horrible :)

ftrace needs basically the same kind of facility as kgdb
needs here.  So bypassing the need for kgdb won't get around
the problem in general.
