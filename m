Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbXFSRwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbXFSRwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbXFSRwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:52:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33846 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbXFSRwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:52:42 -0400
Message-ID: <467817CE.80904@garzik.org>
Date: Tue, 19 Jun 2007 13:52:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Jay Vosburgh <fubar@us.ibm.com>, "David S. Miller" <davem@davemloft.net>,
       Dan Aloni <da-x@monatomic.org>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net
Subject: Re: Why is this patch not in 2.6.22-rc5?
References: <1178862045.3979.33.camel@kane-linux>	<20070511092519.1f34ab34@freepuppy>	<1179130660.3881.23.camel@kane-linux>	<20070514085840.17a343f7@freepuppy>	<20070613094521.GA8860@localdomain>	<20070613155335.47111c67@localhost>	<15712.1181795790@death> <20070619082302.4b9a5c27@localhost.localdomain>
In-Reply-To: <20070619082302.4b9a5c27@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Wed, 13 Jun 2007 21:36:30 -0700
> Jay Vosburgh <fubar@us.ibm.com> wrote:
> 
>> 	The following patch (based on a patch from Stephen Hemminger
>> <shemminger@linux-foundation.org>) removes use after free conditions in
>> the unregister path for the bonding master.  Without this patch, an
>> operation of the form "echo -bond0 > /sys/class/net/bonding_masters"
>> would trigger a NULL pointer dereference in sysfs.  I was not able to
>> induce the failure with the non-sysfs code path, but for consistency I
>> updated that code as well.
>>
>> 	I also did some testing of the bonding /proc file being open
>> while the bond is being deleted, and didn't see any problems there.
>>
>> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
> 	
> Hey David, this patch fixes one of the bugs listed in 2.6.22-rc5
> list. Jay submitted last week but it hasn't made it upstream.

Get him to forward it to me, like he does for other bonding patches...

	Jeff



