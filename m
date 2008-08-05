Return-Path: <linux-kernel-owner+w=401wt.eu-S1761490AbYHEMSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761490AbYHEMSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbYHEMSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:18:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbYHEMSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:18:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
Date: Tue, 5 Aug 2008 14:20:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: jbarnes@virtuousgeek.org, arekm@maven.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200808050153.23537.rjw@sisk.pl> <200808051117.28824.rjw@sisk.pl> <20080805.023734.156470524.davem@davemloft.net>
In-Reply-To: <20080805.023734.156470524.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051420.40032.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of August 2008, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Tue, 5 Aug 2008 11:17:28 +0200
> 
> > Okay, but tg3 evidently wants to set the power state to D0 under a spinlock
> > (without the delay required by the PCI PM spec, but well).
> 
> Please read the rest of your inbox, we found a way to fix
> tg3 to not need to call this under a lock.

Thanks a lot, I've just read the message.

[For the information of the people who are not subscribed to netdev, the fix
patch is at http://marc.info/?l=linux-netdev&m=121791046925274&w=2]

Rafael
