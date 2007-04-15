Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXDOBGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXDOBGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 21:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXDOBGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 21:06:04 -0400
Received: from ozlabs.org ([203.10.76.45]:46174 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXDOBGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 21:06:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17953.31345.138748.170210@cargo.ozlabs.ibm.com>
Date: Sun, 15 Apr 2007 11:05:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>, kaber@trash.net, poemann@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
In-Reply-To: <17953.30429.220756.818283@cargo.ozlabs.ibm.com>
References: <461DC70B.4000500@trash.net>
	<20070413.161635.26523891.davem@davemloft.net>
	<17953.1560.855914.274514@cargo.ozlabs.ibm.com>
	<20070414.100441.15000708.davem@davemloft.net>
	<17953.30429.220756.818283@cargo.ozlabs.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> So this doesn't change process_input_packet(), which treats the case
> where the first byte is 0xff (PPP_ALLSTATIONS) but the second byte is
> 0x03 (PPP_UI) as indicating a packet with a PPP protocol number of

I meant "the second byte is NOT 0x03", of course.

Paul.
