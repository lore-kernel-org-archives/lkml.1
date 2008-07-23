Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYGWAXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYGWAXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYGWAWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:22:54 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:48969 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751768AbYGWAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:22:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dsMiz3bpqqa4lWUoymnO/FQuJZiPJGJ53xps2bgwCijet9vdpZYVkK13L+Nhx2gV+Uf7lPc60Fsher1ZFuEsHy571+b294fRR6WXzqHlKdREFoPcKrlAJDEfEYu2S/CmgBmWSsvSIrLsXLyPj8DQ1eTqdUdw9mHYYUyTlH+Gccw=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev->next should be next (ffff88003b8f82f8)
Date: Tue, 22 Jul 2008 17:22:47 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080721223038.GA2051@suse.de> <20080722134042.GA14315@elte.hu> <20080723001043.GB8477@suse.de>
In-Reply-To: <20080723001043.GB8477@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221722.47670.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008, Greg KH wrote:
> On Tue, Jul 22, 2008 at 03:40:42PM +0200, Ingo Molnar wrote:
> > 
> > hi Greg, David,
> > 
> > -tip randconfig boot testing just found this USB boot crash regression:
> > 
> > dummy_udc dummy_udc: enabled ep-a (ep1in-bulk) maxpacket 512
> > dummy_udc dummy_udc: enabled ep-b (ep2out-bulk) maxpacket 512
> 
> Wierd, if we don't have the hardware, this shouldn't be a problem, right
> David?

Getting ready to reproduce it ... it takes a while to resync my
patch queue with git-current.  :)

- Dave
