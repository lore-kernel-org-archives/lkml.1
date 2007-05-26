Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbXEZF7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbXEZF7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXEZF7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:59:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:34021 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752359AbXEZF7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:59:32 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18wPBc9CWUw2Jk2LiLdokDvG4oMSNK3ZPCZ5tYxOJ
	+bwTtXph6vmSXm
Date: Sat, 26 May 2007 07:59:30 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: e1000 in 2.6.21.2 and even older, like 2.6.13: eth0 does not exist but eth1 does
Message-ID: <20070526055930.GA8647@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	LKML <linux-kernel@vger.kernel.org>
References: <46560AE6.10307@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46560AE6.10307@ribosome.natur.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2007.05.25 00:00:06 +0200, Martin MOKREJŠ wrote:
>  Let me emphasize ifconfig(1) does only show loopback device all the time.
> Finally I found that in /proc/net/dev there is a row for "lo:" and "eth1".
> Yes, the network card is recognized as eth1. Blindly running 'ifconfig eth1 
> $IP'

ifconfig shows only interfaces that are "up" unless you run it with -a

> I think there is sometimes logged wrong device name to syslog, I do not 
> know why.
> But it always shows eth0 after inserting the e1000 module? Removing the 
> module
> disables the IRQ for the device, re-inserting the module again claims it is
> eth0 ... but it is eth1, I know now. The network card is wired into the 
> motherboard,

The log entries are probably right, but userspace renames the device
shortly after. Check /etc/iftab and/or your udev rules.

HTH
Björn
