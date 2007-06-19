Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbXFSP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbXFSP3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXFSP3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:29:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbXFSP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:29:18 -0400
Date: Tue, 19 Jun 2007 08:23:02 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jay Vosburgh <fubar@us.ibm.com>, "David S. Miller" <davem@davemloft.net>
Cc: Dan Aloni <da-x@monatomic.org>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Why is this patch not in 2.6.22-rc5?
Message-ID: <20070619082302.4b9a5c27@localhost.localdomain>
In-Reply-To: <15712.1181795790@death>
References: <1178862045.3979.33.camel@kane-linux>
	<20070511092519.1f34ab34@freepuppy>
	<1179130660.3881.23.camel@kane-linux>
	<20070514085840.17a343f7@freepuppy>
	<20070613094521.GA8860@localdomain>
	<20070613155335.47111c67@localhost>
	<15712.1181795790@death>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007 21:36:30 -0700
Jay Vosburgh <fubar@us.ibm.com> wrote:

> 
> 	The following patch (based on a patch from Stephen Hemminger
> <shemminger@linux-foundation.org>) removes use after free conditions in
> the unregister path for the bonding master.  Without this patch, an
> operation of the form "echo -bond0 > /sys/class/net/bonding_masters"
> would trigger a NULL pointer dereference in sysfs.  I was not able to
> induce the failure with the non-sysfs code path, but for consistency I
> updated that code as well.
> 
> 	I also did some testing of the bonding /proc file being open
> while the bond is being deleted, and didn't see any problems there.
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
	
Hey David, this patch fixes one of the bugs listed in 2.6.22-rc5
list. Jay submitted last week but it hasn't made it upstream.
