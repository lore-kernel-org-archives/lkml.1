Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbYFAQCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbYFAQCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYFAQCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:02:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48108
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753205AbYFAQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:01:31 -0400
Date: Sun, 01 Jun 2008 09:01:27 -0700 (PDT)
Message-Id: <20080601.090127.193706900.davem@davemloft.net>
To: pazke@pazke.donpac.ru
Cc: jesper@krogh.cc, Matheos.Worku@Sun.COM, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080601072528.GA786@pazke.donpac.ru>
References: <4835A007.7020601@krogh.cc>
	<20080522.104145.193700531.davem@davemloft.net>
	<20080601072528.GA786@pazke.donpac.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Panin <pazke@pazke.donpac.ru>
Date: Sun, 1 Jun 2008 11:25:28 +0400

> On 143, 05 22, 2008 at 10:41:45 -0700, David Miller wrote:
> > For now, yes.  The transmit path itself in the generic network
> > device layer is where the serialization comes from.
> 
> BTW does this problem affects bonded interfaces ?

The toplevel bond device uses lockless transmit because
it does not queue, so the arity of the locking is equal
to the arity of the number of slave devices sitting
under the toplevel bond device.
