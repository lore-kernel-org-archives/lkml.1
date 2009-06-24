Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZFXHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZFXHCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZFXHCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:02:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49227
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbZFXHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:02:08 -0400
Date: Wed, 24 Jun 2009 00:02:11 -0700 (PDT)
Message-Id: <20090624.000211.175032622.davem@davemloft.net>
To: hawk@comx.dk
Cc: paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, axboe@kernel.dk, kaber@trash.net,
       christine.caulfield@googlemail.com, Trond.Myklebust@netapp.com,
       linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
       yoshfuji@linux-ipv6.org, shemminger@linux-foundation.org,
       linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
       linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 00/10] We must use rcu_barrier() on module unload
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090623150330.22490.87327.stgit@localhost>
References: <20090623150330.22490.87327.stgit@localhost>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <hawk@comx.dk>
Date: Tue, 23 Jun 2009 17:03:53 +0200

> This patch series is an attempt to cleanup the entire tree, for
> potential oops'es during module unload, due to outstanding RCU
> callbacks. (My last rcu_barrier patch series only addressed net/).

This series has net/ stuff too :-)

I'll let the networking cases sit for a while and get review before
I apply them.
