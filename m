Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZCKQWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZCKQWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZCKQWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:22:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57297
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbZCKQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:22:16 -0400
Date: Wed, 11 Mar 2009 09:22:02 -0700 (PDT)
Message-Id: <20090311.092202.126273766.davem@davemloft.net>
To: john.dykstra1@gmail.com
Cc: tmb@mandriva.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: BUG when unloading bonding on 2.6.29-rc7-git3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1236727393.7958.38.camel@Maple>
References: <49B6CA4A.2040506@mandriva.org>
	<1236727393.7958.38.camel@Maple>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Dykstra <john.dykstra1@gmail.com>
Date: Tue, 10 Mar 2009 23:23:13 +0000

> ipv6:  Fix BUG when disabled ipv6 module is unloaded
> 
> Do not try to "uninitialize" ipv6 if its initialization had been skipped
> because module parameter disable=1 had been specified.
> 
> Reported-by:  Thomas Backlund <tmb@mandriva.org>
> Signed-off-by: John Dykstra <john.dykstra1@gmail.com>

I'm going to apply this by hand.

But if you are going to submit patches in the future you have to fix
the corruptions and mangling that your email client does to them.
