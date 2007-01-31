Return-Path: <linux-kernel-owner+w=401wt.eu-S1030223AbXAaQJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223AbXAaQJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030221AbXAaQJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:09:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46552 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030212AbXAaQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:09:05 -0500
Date: Wed, 31 Jan 2007 16:21:23 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [BUG]: 2.6.19.2: Weird serial core issue
Message-ID: <20070131162123.67e22e23@localhost.localdomain>
In-Reply-To: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com>
References: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When I telnet my board and run the following command:
> ---- root:~> stty -F /dev/ttyS0 -crtscts
> 
> I got the following result from the console of my board:
> ---- root:~>new_termios flag: 0x1cb1, old_termios flag: 0x80001cb1
> 
> That's correct. CRTSCTS flag is clear
> 
> But when I type "ENTER" key on the console, I got:
> ----root:~>new_termios flag: 0x80001cb1, old_termios flag: 0x1cb1

What code is running on that console at the time. Most likely that user
code is also saving/restoring terminal settings so overwrite yours
