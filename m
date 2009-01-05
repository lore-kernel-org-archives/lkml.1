Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZAEWoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZAEWoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZAEWoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:44:44 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35201 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751445AbZAEWon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:44:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=p8bcvjWKN5gLmW6J8ktagbuHLJGomJJ/nlwK98uNLeqUBwBHnKkW4gQgpFH5T4L2cFW7PUSefmRMviJdl9BVBB7WX5ZeFouRLWbBqFExJ3W/PMyOl9Am6triKqDZzdq0n+XawjrM35ml4pac/oBhm8KTt1IXmBiNw6apQVckzSI=  ;
X-YMail-OSG: .BWIxLkVM1kEo36_ew3e6SnEnokGqkgZ8Y9f7BT5EqJd0P6R7Bl7Dv8f2xwvPLRnHNd_AFpEUpVw7FY6pyzxWNJpPy.1ThvMtJRzsL.QTHdQUmcVUmZY.eORQ3CyQOxwR1JO__ipxKPLXf7KCjB5WVgs
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: quirk_usb_disable_ehci takes 2x 1.5s on boot
Date: Mon, 5 Jan 2009 14:44:40 -0800
User-Agent: KMail/1.9.10
Cc: USB list <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <49620DF7.9040006@gmail.com>
In-Reply-To: <49620DF7.9040006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051444.41232.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Jiri Slaby wrote:
> Hi,
> 
> I don't know since which moment (maybe I changed something in bios, but usb
> legacy kbd was ever enabled), but quirk_usb_disable_ehci takes for both of my
> ehci controllers 1.5 s.
> 
> More precisely, the time is spent in
> pci_write_config_byte(pdev, offset + 3, 1);
> by
> outb((u8)value, 0xCFC + (reg & 3));
> from pci_conf1_write deep in the callstack.
> 
> Is there any workaround known or something.

I've never heard of pci_write_config_byte() taking enough time
to be visible without a PCI bus analyser... sorry, no clue.

- Dave


> Turning legacy usb off is not an 
> option, I want to control grub.
> 
> Thanks.
> 
> 


