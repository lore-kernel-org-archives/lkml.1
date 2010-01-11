Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224Ab0AKQ6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0AKQ6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591Ab0AKQ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:58:06 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:65325 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0AKQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s2jhYq7rNE6VMjr0WH/Ym/lLF42QbZKI6t6LW+WKd7bJJh5f16BpJMXm2zNRlcmaVG
         ERQUc7T11DFFU2so1rx6YAj9XyTLlIsDJk9Xub4ZasG0sS/+ZZTaH07EgwvpIR4JXZf8
         uLV10QcXJlz3obq9TAKMZtKZPnUkRv7s1wDiI=
MIME-Version: 1.0
In-Reply-To: <20100111102620.732b574f@lxorguk.ukuu.org.uk>
References: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
	 <20100111001745.21d28340@lxorguk.ukuu.org.uk>
	 <13bb8ce11001101730w640f99p72ecb1204e59f139@mail.gmail.com>
	 <13bb8ce11001102040j37e061fn976ec74595f30232@mail.gmail.com>
	 <20100111102620.732b574f@lxorguk.ukuu.org.uk>
Date: Mon, 11 Jan 2010 10:58:02 -0600
Message-ID: <13bb8ce11001110858m26363081g5f883b13a587f1a8@mail.gmail.com>
Subject: Re: staging/et131x Driver Transmits but does not Receive Packets
From: Daniel Goller <morfic@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That looks like an interrupt problem. With iwlagn and r8169 blacklisted
> see what interrupt number the et131x gets (cat /proc/interrupts) and see
> if it goes up whenever you send/receive stuff.

16:        385        385   IO-APIC-fasteoi   uhci_hcd:usb3, uhci_hcd:usb7, eth1
 it does change as i bring it up with IP and: ping -I eth1 192.168.1.156

This is in 2.6.30.10

You say it would be interesting to see if the driver works in
2.6.29(".0") or just 2.6.29.x in general?

So far i only tried it in 2.6.29.6, and will check interrupts there in
a little while.
