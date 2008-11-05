Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYKEF7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYKEF7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 00:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYKEF7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 00:59:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44018
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbYKEF7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 00:59:06 -0500
Date: Tue, 04 Nov 2008 21:58:39 -0800 (PST)
Message-Id: <20081104.215839.132524253.davem@davemloft.net>
To: mchan@broadcom.com
Cc: linux-kernel@blueteddy.net, daniel.blueman@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1225847763.11369.43.camel@HP1>
References: <49107543.5080207@blueteddy.net>
	<20081104.145242.112948002.davem@davemloft.net>
	<1225847763.11369.43.camel@HP1>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Tue, 04 Nov 2008 17:16:03 -0800

> I think this is no longer a limitation.  The GSO code will take care
> of ECN properly if the hardware does not support it when doing TSO.

Hmm, good point, but if that is what happens I don't know if I agree
with it.

If "take care of ECN" means doing TSO in software, that's in my
opinion the wrong thing to do.
