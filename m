Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbZJMPHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbZJMPHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbZJMPHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:07:52 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:36775 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZJMPHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:07:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bySxvGiAH+59hir8lm//jNu3KLfZl2R3cwgx3X0YZgfkIxgZR86XHKRi+rrpcvxsEb
         +Qt7eZTFQuOEfEqljyUWpOvaNxHX1xky9o+6TIM/8bVfvFENciLgzJLHOvQ5f3kU0Z0f
         5sPCDq97Nv+R5n5+eOoeuh8l3VyGAsMr+ooys=
MIME-Version: 1.0
In-Reply-To: <ba1f10320910130446g33264abfy845e28856e2e6f69@mail.gmail.com>
References: <ba1f10320910130446g33264abfy845e28856e2e6f69@mail.gmail.com>
Date: Tue, 13 Oct 2009 11:07:15 -0400
Message-ID: <ba1f10320910130807r3f8ed8a5h543c14259d1bd1b@mail.gmail.com>
Subject: Re: Intel on-board NIC negotiates at 10mbps instead of 1gbps (new 
	Intel P55KG motherboard), driver bug?
From: Justin Piszcz <jpiszcz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 7:46 AM, Justin Piszcz <jpiszcz@gmail.com> wrote:
> Hello,
>
> I recently purchased/installed an Intel DP55KG motherboard and when I
> boot from the System Rescue CD (1.3.0) the on-board NIC only
> negotiates at 10mbps, when I plug the same cable into two other Intel
> x1 PCI-e nics, they negotiate at 1gbps without any issue.  My old
> system also negotiated at 1gbps (a DG965WH) board.
>
> I understand support for chip has recently been added to the e1000e
> driver, has this been resolved in newer kernels?
>
> I am asking as I am still running memtest etc before putting the box
> in production, thanks.
>
> From the logs:
>
> e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
> e1000e: Copyright (c) 1999-2008 Intel Corporation.
> e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> e1000e 0000:00:19.0: pci_enable_pcie_error_
> reporting failed 0xfffffffb
> e1000e 0000:00:19.0: setting latency timer to 64
> e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
> 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) (mac address)
> 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> 0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: ffffff-0ff
>
> e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
> e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> e1000e: eth0 NIC Link is Up 10 Mbps Full Duplex, Flow Control: RX
> 0000:00:19.0: eth0: 10/100 speed: disabling TSO
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> eth0: no IPv6 routers present
>
> Please cc as I am not on the lists, thanks.
>
> (resent as plain-text)
>
> Justin.
>


I spoke with Intel, they said they do not support Linux :-P

"However, Linux* has not been tested on this desktop board and we do
not offer any drivers for that operating system."

-- Can someone from Intel on the list (or linux-net) comment on this?
If the problem still occurs with the latest 2.6.31-rcX, I should try
and/or use the latest e1000e driver from here:
http://sourceforge.net/projects/e1000/ -- aside from that, are there
any other workarounds (if the problem persists)?

I have used the same cable with 3 different NICs (two x1 PCI-e) and
the last system I had was PCI-e (on-board) all negotiated 1gbps, this
one though only negotiates at 10mbps duplex.

Is this a known bug?

Justin.
