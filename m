Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbXBSE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbXBSE6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 23:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXBSE6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 23:58:18 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:36507 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXBSE6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 23:58:16 -0500
Date: Sun, 18 Feb 2007 20:58:15 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Andy <genanr@emsphone.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: console scroll lock causes DOS
In-Reply-To: <20070207194137.GA25325@thumper2>
Message-ID: <Pine.LNX.4.64.0702182057120.12754@twinlark.arctic.org>
References: <20070207194137.GA25325@thumper2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, Andy wrote:

> If the scroll lock is on and there is a bunch of console output, the machine
> will eventually stop responding to the network, until scroll lock is turned
> off (at sometimes that doesn't even help). 
> 
> Easy test:
> 
> hit scroll lock
> do a few echo t > /proc/sysrq-trigger on that machine from a ssh/telnet session
> and it should stop responding after two or three of them.
> 
> This is bad (for me) because we have a stupid switch box that uses scroll
> lock to bring up the system selection menu, so sometimes scroll lock gets
> left on by accident, and the machine eventually locks up.

something similar happens on serial console with hardware flow control if 
the other side goes away.  on some boxes i've wired special connectors 
with CTS=RTS to avoid this... mind you i haven't tested this problem in 
years.

-dean
