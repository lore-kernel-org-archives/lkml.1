Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbXJHWeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbXJHWeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXJHWdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:33:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57050
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbXJHWdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:33:54 -0400
Date: Mon, 08 Oct 2007 15:33:53 -0700 (PDT)
Message-Id: <20071008.153353.58431888.davem@davemloft.net>
To: hadi@cyberus.ca
Cc: jeff@garzik.org, peter.p.waskiewicz.jr@intel.com, krkumar2@in.ibm.com,
       johnpol@2ka.mipt.ru, herbert@gondor.apana.org.au, kaber@trash.net,
       shemminger@linux-foundation.org, jagana@us.ibm.com,
       Robert.Olsson@data.slu.se, rick.jones2@hp.com, xma@us.ibm.com,
       gaagaan@gmail.com, netdev@vger.kernel.org, rdreier@cisco.com,
       mingo@elte.hu, mchan@broadcom.com, general@lists.openfabrics.org,
       kumarkr@linux.ibm.com, tgraf@suug.ch, randy.dunlap@oracle.com,
       sri@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: parallel networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1191882618.4373.99.camel@localhost>
References: <470A3D24.3050803@garzik.org>
	<20071008.141154.107706003.davem@davemloft.net>
	<1191882618.4373.99.camel@localhost>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: jamal <hadi@cyberus.ca>
Date: Mon, 08 Oct 2007 18:30:18 -0400

> Very quickly there are no more packets for it to dequeue from the
> qdisc or the driver is stoped and it has to get out of there. If you
> dont have any interupt tied to a specific cpu then you can have many
> cpus enter and leave that region all the time.

With the lock shuttling back and forth between those cpus, which is
what we're trying to avoid.

Multiply whatever effect you think you might be able to measure due to
that on your 2 or 4 way system, and multiple it up to 64 cpus or so
for machines I am using.  This is where machines are going, and is
going to become the norm.
