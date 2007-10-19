Return-Path: <linux-kernel-owner+w=401wt.eu-S935127AbXJSHwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbXJSHwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXJSHwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:52:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50782
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbXJSHwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:52:32 -0400
Date: Fri, 19 Oct 2007 00:52:45 -0700 (PDT)
Message-Id: <20071019.005245.77429272.davem@davemloft.net>
To: xemul@openvz.org
Cc: olof@lixom.net, netdev@vger.kernel.org, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix race between sk_filter reassign and sk_clone()
From: David Miller <davem@davemloft.net>
In-Reply-To: <47185E9E.1030102@openvz.org>
References: <20071019022947.GA29560@lixom.net>
	<20071018.215521.28810637.davem@davemloft.net>
	<47185E9E.1030102@openvz.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 19 Oct 2007 11:37:02 +0400

> David Miller wrote:
> > From: Olof Johansson <olof@lixom.net>
> > Date: Thu, 18 Oct 2007 21:29:47 -0500
> > 
> >> So, looks like rcu_dereference() returned NULL. I don't know the
> >> filter code at all, but it seems like it might be a valid case?
> >> sk_detach_filter() seems to handle a NULL sk_filter, at least.
> >>
> >>
> >> So, this needs review by someone who knows the filter, but it fixes the
> >> problem for me:
> 
> Yes. The NULL filter is a valid case, when there are no
> filters attached at all. So this fix is correct.
> 
> Thanks, Olof. Sorry, Dave :(

No worries, thanks for reviewing.
