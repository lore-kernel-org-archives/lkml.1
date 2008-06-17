Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYFQVdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYFQVdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYFQVdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:33:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:5241 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbYFQVdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l7yZTq/4jS/dDW+kyxDoMKB2lU3QTy2WgRPTHkPVu8ZSdqMVW4BbKxrrZMS4o3LZdw
         EIx0m6tH25JjcUV257mUrijngmzcfXBgIF5x4/NwRJMHXODC6nwx78HX88R2XKtSBx5U
         9Isdf9XY3bgXTqZIK6tOK7lxp0mBDOOGc7bJs=
Message-ID: <bec9a5870806171433gf74e251m6742e066960d6ab4@mail.gmail.com>
Date: Wed, 18 Jun 2008 00:33:21 +0300
From: "Nameer Yarkon" <nameer.yarkon@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Serial problem and request for guidance..
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080616130353.1b80fdd0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bec9a5870806160514w79448b53ya622f4752253ae5b@mail.gmail.com>
	 <20080616130353.1b80fdd0@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 3:03 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Some of my serial rx data gets lost.
>
> Which hardware ?

It's a range of platforms/kernel versions and scenarios.
Currently it happens with a bluetooth device connected to standard UART
on ARM (OMAP) with an old 2.6.14 kernel, but only when I enable the
debug macros of the line discipline code (hci_h4, hci_ldisc,..).
When a big chunk of data arrives, more than
half of it is lost. even on 115200. But when I turn of the debug macros (BT_DBG
macros which are simply a bunch of prinks) the problem disappears. So I suspect
there are some nasty timing issues which lead to data loss.

I encountered similar problems last year even on a PC, with pre 2.6.21 kernels
(around 2.6.19 or even earlier IIRC) but it was all gone with 2.6.21 and 2.6.22.
Currently I have totally different machines, and these devices tend now to come
with USB-to-serial connectors so I'm not quite sure about up-to-date
kernels yet.

All I can say is that it is nasty and very hard to debug, and I'm not quite sure
how can I debug it as I find the serial/tty subsystems a bit perplexing.

I know this is not necessarily relevant to the tip of the kernel, and it still
lacks many details, but any guidance towards how can I debug it will
be much appreciated. If I will successfully reproduce it with a current
kernel I promise a full and detailed bug report.

Thank you for your time and patience !
Nameer.
