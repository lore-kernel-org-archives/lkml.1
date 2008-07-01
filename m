Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYGAMWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYGAMWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYGAMW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:22:27 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48398 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbYGAMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:22:26 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for June 30 (USB: cdc-acm)
Date: Tue, 1 Jul 2008 14:22:45 +0200
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <20080630114332.b797e5e4.randy.dunlap@oracle.com> <20080630190125.GA3553@kroah.com>
In-Reply-To: <20080630190125.GA3553@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011422.46604.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 30 Juni 2008 21:01:25 schrieb Greg KH:
> On Mon, Jun 30, 2008 at 11:43:32AM -0700, Randy Dunlap wrote:
> > cdc-acm fails to build when CONFIG_PM=n:
> > 
> > linux-next-20080630/drivers/usb/class/cdc-acm.c: In function 'acm_suspend':
> > linux-next-20080630/drivers/usb/class/cdc-acm.c:1263: error: 'struct usb_device' has no member named 'auto_pm'
> > make[4]: *** [drivers/usb/class/cdc-acm.o] Error 1
> 
> Yeah, known issue due to the pm and usb trees conflicting here.  It will
> be fixed up at the merge time with Linus.
> 
> Or so Alan promises :)

No, I caused this. It'll require some #ifdefs. A patch is compiling.

	Regards
		Oliver
