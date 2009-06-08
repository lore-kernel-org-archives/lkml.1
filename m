Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZFHQkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZFHQkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZFHQkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:40:42 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4741 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZFHQkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:40:41 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Mon, 8 Jun 2009 09:40:38 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Christian Kujau" <lists@nerdbynature.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Matthew Carlson" <mcarlson@broadcom.com>
Subject: Re: tg3 stops working when NFS is involved
Message-ID: <20090608164038.GA8825@xw6200.broadcom.net>
References: <alpine.DEB.2.01.0906072115420.6439@bogon>
 <alpine.DEB.2.01.0906072215000.6439@bogon>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0906072215000.6439@bogon>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-WSS-ID: 6633E08C3BW49851995-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 10:18:52PM -0700, Christian Kujau wrote:
> On Sun, 7 Jun 2009, Christian Kujau wrote:
> > anything else - so, I figure it's not a client problem. And I'm not sure 
> > if it's NFS problem either, because restarting the NFS server doesn't do 
> > anything, I really have to rmmod/modprobe the tg3 module. OTOH, I cannot 
> > reproduce this without NFS: running e.g. iperf (TCP, UDP) did not trigger 
> > it.
> 
> Just tested with Samba - after a few megabytes of transmitted data, tg3 stops 
> working, with no messages printed in the kernel log :-\
> 
> I don't know why iperf does not trigger it though....

Hi Christian.  This seems to be a common problem with the 5906 on some
notebooks.  The word on the street is that turning sg off through
ethtool seems to avoid the problem.  While I dig deeper into this
problem, you could try that and see if it helps you.

