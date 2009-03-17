Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZCQT2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZCQT2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZCQT2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:28:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56139
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbZCQT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:28:30 -0400
Date: Tue, 17 Mar 2009 12:28:16 -0700 (PDT)
Message-Id: <20090317.122816.246078801.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, jwboyer@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090317160635.GE10092@Krystal>
References: <20090317013220.GA22474@Krystal>
	<20090317050135.GB6859@linux.vnet.ibm.com>
	<20090317160635.GE10092@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Tue, 17 Mar 2009 12:06:35 -0400

> But powerpc has non-maskable interrupts, so for less than 4 cycles, I
> think it's better to stay with the local_t variant to be NMI-safe.

Sparc64 has non-maskable interrupts too btw.
