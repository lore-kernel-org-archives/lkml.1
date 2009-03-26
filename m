Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZCZAYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZCZAYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZCZAYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:24:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34385
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbZCZAYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:24:39 -0400
Date: Wed, 25 Mar 2009 17:24:27 -0700 (PDT)
Message-Id: <20090325.172427.98374994.davem@davemloft.net>
To: jpirko@redhat.com
Cc: fubar@us.ibm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, bonding-devel@lists.sourceforge.net,
       kaber@trash.net, mschmidt@redhat.com, dada1@cosmosbay.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
 properly in bridge -try3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090325174405.GM3437@psychotron.englab.brq.redhat.com>
References: <20090325151937.GI3437@psychotron.englab.brq.redhat.com>
	<28445.1237998713@death.nxdomain.ibm.com>
	<20090325174405.GM3437@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Wed, 25 Mar 2009 18:44:05 +0100

> Wed, Mar 25, 2009 at 05:31:53PM CET, fubar@us.ibm.com wrote:
> >Jiri Pirko <jpirko@redhat.com> wrote:
> >
> >>Basically here's what's going on. In every mode, bonding interface uses the same
> >>mac address for all enslaved devices. Except for mode balance-alb. 
> >
> >	I think you mean "only balance-alb will simultaneously use
> >multiple MAC addresses across different slaves."  Yes?
> Yes I do. I will refolmulate the phrase and repost the patch if you want...

I'll let you guys discuss this some more.

It looks like we could have some more tweaks before this patch is
finalized.
