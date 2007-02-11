Return-Path: <linux-kernel-owner+w=401wt.eu-S1750757AbXBKRwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbXBKRwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXBKRwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:52:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:4028 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXBKRwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b8xqSF81g5wCiNDtUNsgVi0d9sM4Yqsw2tR2xvcykpX95p8OjhDiBmySeB/+oY5snK9t/5K56Sw1E7PoKCi2XwmyZ62x3Rih3KQtYukboPocZBlmLfiTjrMqw+ZIQo73sHaq/x5rAI6HEabKM9dEJNURZSmYR0vZ/mGsMQS6Bj4=
Message-ID: <8d158e1f0702110952m480ba28atae6d020f6ecff9aa@mail.gmail.com>
Date: Sun, 11 Feb 2007 18:52:01 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: libsata doesn't like bus without master
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CF54C7.7050400@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.kM2jAt0lhoofVm0+pIia0W2vzoo@ifi.uio.no>
	 <45CF54C7.7050400@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Patrick Ale wrote:
> > Something unrelated to the tests I am doing.
> >
> > I found out that the libsata driver doesn't really cope or likes the
> > idea that you might have a controller without a master drive
> > configured.
> >
> > In this case on ATA2 I have a CDROM drive, connected as slave.
> > ATA: abnormal status 0x7F on port 0x177
> > ATA: abnormal status 0x7F on port 0x177
> > ata2.01: ATAPI, max UDMA/66
> > ata2.01: configured for UDMA/66
>
> Having a single drive on the channel configured as slave is not really a
> legal configuration. (I believe the ATA standards say that it's
> something that a host controller/driver/OS is allowed to support, but it
> is not required to.) A single drive should always be set to master (and
> connected to the end of the cable and not the middle, by the way).

It is very legal when one of your harddisks blows out and you take it
out temporarely and have no money for a replacement IMO. But then
again, this is probably an abnormality.

But still, it even complains when no drive is attached to a controller
at all. Since when you buy an add-on PCI card you get 2 connectors
even when you want to add one harddisk how does one deal with that?
