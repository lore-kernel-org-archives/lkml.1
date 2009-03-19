Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZCSKWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZCSKWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZCSKV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:21:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46854
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbZCSKV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:21:57 -0400
Date: Thu, 19 Mar 2009 03:21:43 -0700 (PDT)
Message-Id: <20090319.032143.08849045.davem@davemloft.net>
To: jpirko@redhat.com
Cc: shemminger@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
 properly in bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090319084444.GA4123@psychotron.englab.brq.redhat.com>
References: <20090316111127.GB3484@psychotron.englab.brq.redhat.com>
	<20090318.232003.30974750.davem@davemloft.net>
	<20090319084444.GA4123@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Thu, 19 Mar 2009 09:44:45 +0100

> Yes I was looking at this thing yesterday (uc_list). But this list serves
> to different purpose. Do you think that it will be correct to use it for this? I
> would maybe like to make a new list similar to this for our purpose
> (say addr_list). I think it would be more correct.

Whatever you do with that list privately inside of the bonding
driver should be fine.

It might upset something in the generic code if you don't clean
it up before deregistration of the bonding device, so just be
tidy.
