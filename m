Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbXEQGEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbXEQGEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXEQGEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:04:39 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:54439 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbXEQGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:04:38 -0400
Subject: Re: 2.6.21-rc7: BUG: sleeping function called from invalid context
	at net/core/sock.c:1523
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: David Miller <davem@davemloft.net>, satyam.sharma@gmail.com,
       Greg KH <gregkh@suse.de>, jeremy@goop.org, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705170116260.13706@twin.jikos.cz>
References: <1179317775.10069.77.camel@violet>
	 <Pine.LNX.4.64.0705161418250.25986@twin.jikos.cz>
	 <Pine.LNX.4.64.0705170102290.13706@twin.jikos.cz>
	 <20070516.161609.108116976.davem@davemloft.net>
	 <Pine.LNX.4.64.0705170116260.13706@twin.jikos.cz>
Content-Type: text/plain
Date: Thu, 17 May 2007 08:04:29 +0200
Message-Id: <1179381869.10069.112.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > > I have just verified that this locking scheme is indeed correct. So you 
> > > can add
> > > 
> > > 	Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > > 
> > > if you wish to, and submit the patch to Andrew.
> > I guess I don't get sent networking patches any more?
> > :-)
> 
> Well, this is bluetooth-specific, but it seemed to me that Marcel wasn't 
> going to send pull requests to Linus any time soon, therefore I thought 
> going through akpm is a thing to do.

actually everything net/ related goes to Dave first. No exception. This
includes the Bluetooth subsystem. I even send drivers/bluetooth/ through
Dave before they go to Linus.

> Honestly, I really don't care through which tree this goes in, so sorry if 
> any offence was caused here :)

Having these small ones passed through Andrew is only a convenience
since he is really good in picking them up and make sure that they get
merged by Linus.

Regards

Marcel


