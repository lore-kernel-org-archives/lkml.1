Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYKFVZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYKFVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYKFVY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:24:58 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:7553 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYKFVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:24:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KPQEQxIiAjGTGNON/xufuEekLPFLwI8pnWfnaNYnJGU/a7Fg5CYmk3rjzbMbEmOWEX
         rHUdKBY40Hk/nhbjR36YwFxg5lEgw+iHVNzwYsRVWuqdAwQee2hYTOcSTw59gwU6WdKG
         EComm9a1vF0e7yLsklHxLL3VoZovgwRX9ID3Y=
Message-ID: <4913609F.7050607@gmail.com>
Date: Thu, 06 Nov 2008 22:24:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: sharing interrupt between PCI device
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>	 <4910E8AC.7050407@shaw.ca>	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>	 <49115AFC.2030400@gmail.com>	 <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>	 <8d6898730811052211k695d208r53609701af633c2d@mail.gmail.com> <8d6898730811052344q218fc450i8c36fcd9e119d060@mail.gmail.com>
In-Reply-To: <8d6898730811052344q218fc450i8c36fcd9e119d060@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2008 08:44 AM, Nobin Mathew wrote:
> Hi
> 
> can anybody point to some reference device drivers where PCI interrupt
> sharing is implemented properly.

Sorry, I still don't understand the setup. You have two separate pci devices,
both with the same irq number and pci_disable_device on one of them stops irqs
on the second?
