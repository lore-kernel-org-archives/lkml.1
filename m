Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZCIP6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZCIP6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZCIP5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:57:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:45163 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbZCIP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KftQVPVEHnkn1VZpZxTH2M/LBXPqdoXnsgws+aoFaMuc7wH6ILqRtc8w4DIKHD0/Dd
         JRUNxoYci8nP/lGjz/1BjGLQfTXbmxv7EsQiA2wYXT8Ws+trg4nzQdRMmF1m8zDtEw6f
         2GW/Bzzjk9G9Ie5ri2NfegyuVgXubg0/kIBt8=
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0903091050280.3778-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0903091050280.3778-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 17:57:33 +0200
Message-Id: <1236614253.17511.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 10:53 -0400, Alan Stern wrote:
> On Mon, 9 Mar 2009, Maxim Levitsky wrote:
> 
> > Sorry, sorry, sorry.
> > 
> > is was the CONFIG_USB_EHCI_TT_NEWSCHED that did it.
> > I confused both options, without the above option printer works
> > flawlessly.
> 
> Is your printer connected directly to the computer, or does it go 
> through a hub?  (If it is connected directly then EHCI_TT_NEWSCHED 
> should not affect it at all.)
> 
> If it does go through a hub, does it behave better when you attach it 
> directly?
> 
> Alan Stern
> 
No, it is connected directly.
Just tried 'bad' driver, and firmware upload failed

Do you mean that CONFIG_USB_EHCI_TT_NEWSCHED doesn't affect the driver
at all when no hub is presented?

Btw, at least according to lsusb -t, there are no internal hubs in the
printer.


But it can be a coincidence, it seems that with 'bad' driver printer
works 'better' to as it failed back few days ago much more often, maybe
cable is bad, don't know, but according to the web these printers
1018/1020.. have usb problems, there is even a readme for that in
foo2zjz  

I try to use the 'good' driver 
(without CONFIG_USB_EHCI_TT_NEWSCHED) for some time.


Best regards,
	Maxim Levitsky

