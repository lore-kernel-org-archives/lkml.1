Return-Path: <linux-kernel-owner+w=401wt.eu-S965865AbXCSPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbXCSPL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965872AbXCSPL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:11:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47092 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965861AbXCSPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:11:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: mst@dev.mellanox.co.il, kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
References: <20070318224234.GP11078@mellanox.co.il>
	<20070318.171337.112622504.davem@davemloft.net>
	<m3aby94x6o.fsf@maxwell.lnxi.com>
	<20070318.231316.59470365.davem@davemloft.net>
Date: Mon, 19 Mar 2007 09:10:16 -0600
In-Reply-To: <20070318.231316.59470365.davem@davemloft.net> (David Miller's
	message of "Sun, 18 Mar 2007 23:13:16 -0700 (PDT)")
Message-ID: <m1r6rlxo9z.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:


> I think the thing to do is to just leave the loopback references
> in place, try to unregister the per-namespace loopback device,
> and that will safely wait for all the references to go away.

Right.  The only thing I have found that needs to be changed so
far in this area is specifying which loopback device I want
to replace it with.

> If you do it that way, you should need absolutely no changes to
> the other code in this area.
>
> As per Herbert, I think he works on Xen rather than vserver :-)
> Perhaps you're thinking of Alexey Kuznetsov or another one of the
> vserver guys.

I think you are thinking of a different Herbert.  I was thinking of
Herbert Poetzl the vserver maintainer.  Alexey works on OpenVZ.

Until we get the basic architecture merged they are rival projects.

Eric
