Return-Path: <linux-kernel-owner+w=401wt.eu-S1767013AbXDSUHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767013AbXDSUHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767012AbXDSUHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:07:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46161
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1766983AbXDSUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:07:46 -0400
Date: Thu, 19 Apr 2007 13:07:49 -0700 (PDT)
Message-Id: <20070419.130749.121296555.davem@davemloft.net>
To: paulus@samba.org
Cc: kaber@trash.net, poemann@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
From: David Miller <davem@davemloft.net>
In-Reply-To: <17953.31345.138748.170210@cargo.ozlabs.ibm.com>
References: <20070414.100441.15000708.davem@davemloft.net>
	<17953.30429.220756.818283@cargo.ozlabs.ibm.com>
	<17953.31345.138748.170210@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Sun, 15 Apr 2007 11:05:53 +1000

> I wrote:
> 
> > So this doesn't change process_input_packet(), which treats the case
> > where the first byte is 0xff (PPP_ALLSTATIONS) but the second byte is
> > 0x03 (PPP_UI) as indicating a packet with a PPP protocol number of
> 
> I meant "the second byte is NOT 0x03", of course.

I've applied this patch, thanks Paul.
