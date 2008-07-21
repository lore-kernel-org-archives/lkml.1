Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYGUUqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYGUUqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYGUUqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:46:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40831
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbYGUUqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:46:08 -0400
Date: Mon, 21 Jul 2008 13:46:08 -0700 (PDT)
Message-Id: <20080721.134608.75595942.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: mingo@elte.hu, ischram@telenet.be, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
From: David Miller <davem@davemloft.net>
In-Reply-To: <4884F3D7.4070604@lwfinger.net>
References: <4884E6E6.7010800@lwfinger.net>
	<20080721.132100.128525904.davem@davemloft.net>
	<4884F3D7.4070604@lwfinger.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 21 Jul 2008 15:38:47 -0500

> David Miller wrote:
> > 
> > No further backtrace?  That will tell us what driver is causing
> > this.
> 
> Yes, I have a full backtrace.
> 
> It starts with possible recursive locking in NetworkManager, and goes directly 
> into the Warning - this came from a later pull of Linus's tree.

That helps a lot, I'm looking at this now.

Thanks.
