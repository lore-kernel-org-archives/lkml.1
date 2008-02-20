Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbYBTAcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbYBTAcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYBTAcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:32:39 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:34435 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754998AbYBTAci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:32:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zONKtQmxXG3LcsSJ+WAOF9SAGUDvDNcdw7pXNBdQJTnUy8fL2nfc0FEw1LLpLnGhJmZUsuR84yajtnF8Z1FaBoAm+R7CzKvwyJ1jNRfn04FROMnQyiXW1xK83fcm0b8PChIVZMNt1k1c7FMVnCLpy1KXcK2X3qZol23UiAAul8w=  ;
X-YMail-OSG: H1VM8bUVM1kVnQpy02h9equC9wFBP2K2nTPkHW.SGf_1NXdhtKLCnZQkJntBFAgQ9ZPOphzzbQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andre Tomt <andre@tomt.net>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Tue, 19 Feb 2008 16:32:35 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <47BAF36C.4000509@tomt.net> <200802191049.25869.david-b@pacbell.net> <47BB6083.2050000@tomt.net>
In-Reply-To: <47BB6083.2050000@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802191632.35732.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Andre Tomt wrote:
> 
> > Can you try this diagnostic patch, to see if it reports any messages
> > about IAA and/or IAAD oddities?  There's surely a quick workaround
> > for this, but I'd rather understand the root cause before patching.
> 
> Doesn't seem to have triggered anything. dmesg attached in case I missed 
> anything.

You don't seem to have enabled CONFIG_USB_DEBUG, as the patch instructions
say is needed to get such diagnostics ... I can tell because the startup
messages from USB are pretty minimal.  (See appended, vs what you sent...)

Please try again with USB debugging enabled.

- Dave

ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.2: reset hcs_params 0x102486 dbg=1 cc=2 pcc=4 !ppc ports=6
ehci_hcd 0000:00:02.2: reset portroute 0 0 1 1 1 0 
ehci_hcd 0000:00:02.2: reset hcc_params a086 caching frame 256/512/1024 park
ehci_hcd 0000:00:02.2: park 0
ehci_hcd 0000:00:02.2: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: supports USB remote wakeup
ehci_hcd 0000:00:02.2: irq 22, io mem 0xe8004000
ehci_hcd 0000:00:02.2: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:02.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
...

