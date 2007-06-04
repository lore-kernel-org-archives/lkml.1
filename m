Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbXFDV00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbXFDV00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbXFDVZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:25:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49221
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761615AbXFDVZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:25:43 -0400
Date: Mon, 04 Jun 2007 14:25:57 -0700 (PDT)
Message-Id: <20070604.142557.68139332.davem@davemloft.net>
To: joseph@codesourcery.com
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-arch@vger.kernel.org
Subject: Re: 64-bit syscall ABI issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0706042051280.16431@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.0706042051280.16431@digraph.polyomino.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joseph S. Myers" <joseph@codesourcery.com>
Date: Mon, 4 Jun 2007 20:56:57 +0000 (UTC)

[ added linux-arch which is a great place to discuss these
  kinds of issues. ]

> What should the kernel syscall ABI be in such cases (any case where the 
> syscall implementations expect arguments narrower than registers, so 
> mainly 32-bit arguments on 64-bit platforms)?  There are two obvious 
> possibilities:

In general we've taken the stance that the syscall dispatch
should create the proper calling environment for C code
implementing the system calls, and this thus means properly
sign and zero extending the arguments as expected by the C
calling convention.
