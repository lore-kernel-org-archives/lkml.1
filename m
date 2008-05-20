Return-Path: <linux-kernel-owner+w=401wt.eu-S935791AbYETWqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935791AbYETWqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935734AbYETWp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:45:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54429
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935729AbYETWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:45:56 -0400
Date: Tue, 20 May 2008 15:45:51 -0700 (PDT)
Message-Id: <20080520.154551.54365414.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: crquan@gmail.com, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4/arp.c: Use the exported hex_asc from
 lib/hexdump.c instead
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211323212.5915.220.camel@brick>
References: <1211135864-8235-1-git-send-email-crquan@gmail.com>
	<20080520.153611.204837174.davem@davemloft.net>
	<1211323212.5915.220.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 20 May 2008 15:40:12 -0700

> On Tue, 2008-05-20 at 15:36 -0700, David Miller wrote:
> > From: Denis Cheng <crquan@gmail.com>
> > Date: Mon, 19 May 2008 02:37:44 +0800
> > 
> > > Here the local hexbuf is a duplicate of global const char hex_asc from
> > > lib/hexdump.c, except the hex letters' cases:
> > > 
> > > const char hexbuf[] = "0123456789ABCDEF";
> > > 
> > > const char hex_asc[] = "0123456789abcdef";
> > > 
> > > and here to print HW addresses, the hex cases are not significant.
> > > 
> > > Signed-off-by: Denis Cheng <crquan@gmail.com>
> > 
> > Applied, thanks.
> 
> You may want to use the hex_asc_hi, hex_asc_lo helpers to do the
> mask/shifts for you.

Good idea, I'll revert, Denis can you generate a new patch?

Thanks.
