Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329Ab0AJS00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0AJS00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 13:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660Ab0AJS0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 13:26:25 -0500
Received: from khc.piap.pl ([195.187.100.11]:35644 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab0AJS0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 13:26:25 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Paul G. Allen" <pgallen@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Serial Performance
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
Date: Sun, 10 Jan 2010 19:26:22 +0100
In-Reply-To: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
	(Paul G. Allen's message of "Sat, 9 Jan 2010 10:57:48 -0800")
Message-ID: <m363793jg1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul G. Allen" <pgallen@gmail.com> writes:

> I ran some tests on Windows XP and Linux CentOS 5.1 using the Sun
> NetBeans IDE 6.7.1 profiler. The same Java code on both Linux and XP
> machines, the same model of machine (Dell, Pentium 4 3GHz, 2.5GB
> memory). I am using the Sun comm API currently, and previously I was
> using the Serlio API. In all cases, the profiler shows the serial Tx
> to be about 20x faster (twenty times) on Windows XP than in Linux. It
> takes Linux several seconds to Tx 1024 byte blocks of data over the
> serial port where Windows XP takes a fraction of a second.

I don't know about Java, but I'm using 460 kb/s and 920 kb/s serial
ports and Linux can transmit (and receive) full speed data without any
problem. This includes mobile Pentium III 500 MHz with 460 kb/s NS super
IO chip.

4-port OX16PCI954, PL2303 (max 2) and FTDI2232-based USB dongles also
work as well. I know people use ca. 4 Mb/s async serial (with PPP).

The last time I remember serial IO problems it was 8-port 8251-based ISA
card on 486DX. I think it was reliable at max 19200 b/s.


Perhaps you're requesting hardware (or software) handshaking when it's
unavailable? Or maybe there is some "padding" configured?

I wonder what does strace say about it.
-- 
Krzysztof Halasa
