Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYHCUfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYHCUfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbYHCUfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:35:23 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:46845 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYHCUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:35:22 -0400
Date: Sun, 3 Aug 2008 23:35:13 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: Re: [regression?] usb: new errors during device detection
Message-ID: <20080803203512.GA11185@frodo>
Reply-To: me@felipebalbi.com
References: <200808032211.22483.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808032211.22483.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 03, 2008 at 10:11:21PM +0200, Frans Pop wrote:
> +usb 3-1: new low speed USB device using uhci_hcd and address 2
>  ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
>  ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>  usb usb5: configuration #1 chosen from 1 choice
>  hub 5-0:1.0: USB hub found
> -usb 3-1: new low speed USB device using uhci_hcd and address 2
> +usb 3-1: device not accepting address 2, error -71
> +hub 3-0:1.0: unable to enumerate USB device on port 1

what is this device attached to this port ?

Do you have the device attached before turning on the machine ?
Does it happen if you boot without that device attached and attach
it afterwards ?

Can you please enable CONFIG_USB_DEBUG and resend dmesg output ?

thanks,

-- 
balbi
