Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYIJWfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYIJWfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYIJWfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:35:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42733
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbYIJWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:35:23 -0400
Date: Wed, 10 Sep 2008 15:35:17 -0700 (PDT)
Message-Id: <20080910.153517.23060861.davem@davemloft.net>
To: csnook@redhat.com
Cc: thierry.bultel@wanadoo.fr, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Suggested patch: Sending the FQDN when booting via DHCP
From: David Miller <davem@davemloft.net>
In-Reply-To: <48C73C15.2000103@redhat.com>
References: <48C6B3DA.3040904@wanadoo.fr>
	<48C73C15.2000103@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>
Date: Tue, 09 Sep 2008 23:16:37 -0400

> Thierry wrote:
> > [re-sent without HTML encoding, and to the right aliases ...]
> > Hi all,
> > the following patch can be useful, in order to let the DHCP server accordingly update the DNS, when booting via DHCP.
> > This can be useful for 2 reasons:
> > 1) on small systems, the embedded filesystem may even not have udhcpd
> > 2) when booting nfsroot, the nfs server does not like when udhcpd in invoked, even when requested the same IP address.
> > Here is the patch, for 2.6.27-rc5. (Notice that it is the very first time I deliver a patch for Linux, and I may
> > have missed some points on the procedure, if it is the case I apologize for that). What do you think about it ?
> > Any ideas or comments are welcome.
> 
> This should probably be a kernel command-line option, rather than a static config option.

Also:

1) The submitter's email client corrupted the patch making it unusable anyways,
   it munged tabs into spaces etc.

2) At this point in time ->nodename is going to be something like "(none)" and
   therefore not very useful.  This only gets set after userland has started
   up.

So really, the nodename would need to be specified as well as a command line
option for this to really be useful.
