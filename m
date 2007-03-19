Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbXCSJfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbXCSJfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXCSJfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:35:04 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:54702 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751267AbXCSJfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:35:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=b5Xo2OKhff6Svb+y2F27Bi8yGMeycJD2Vq9qULZoAIWf4v9+1Zn9ifWZmn96KgPj+Qd/ofcud/4RmsQq8QMO39SLoUHqk9jZyWWYgeBKQ4eMLdzC8LEQIFTgPQ20QzQ/dogKK77URszTYERCs9tZTfhUjfhsUExb89OYSi3Drak=;
Date: Mon, 19 Mar 2007 12:34:43 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: David Miller <davem@davemloft.net>
Cc: ebiederman@lnxi.com, mst@dev.mellanox.co.il, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
Message-ID: <20070319093443.GC9387@ms2.inr.ac.ru>
References: <20070318224234.GP11078@mellanox.co.il> <20070318.171337.112622504.davem@davemloft.net> <m3aby94x6o.fsf@maxwell.lnxi.com> <20070318.231316.59470365.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318.231316.59470365.davem@davemloft.net>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> I think the thing to do is to just leave the loopback references
> in place, try to unregister the per-namespace loopback device,
> and that will safely wait for all the references to go away.

Yes, it is exactly how it works in openvz. All the sockets are killed,
queues are cleared, nobody holds references and virtual loopback
can be unregistered just like another device.

Alexey
