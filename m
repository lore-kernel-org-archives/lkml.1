Return-Path: <linux-kernel-owner+w=401wt.eu-S933702AbXHFXao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbXHFXao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764134AbXHFXaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:30:16 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:51319 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765923AbXHFXaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:30:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18103.44797.529894.786033@gargle.gargle.HOWL>
Date: Mon, 6 Aug 2007 19:30:05 -0400
To: Kevin K <k_krieser@sbcglobal.net>
Cc: linux-ppp@vger.kernel.org,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sending raw packets via PPP
In-Reply-To: Kevin K's message of 6 August 2007 17:45:39
References: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
From: James Carlson <carlsonj@workingcode.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin K writes:
> Is it possible to send raw packets via ppp under Linux?
> 
> More specifically, in 2.4 series kernels such as RH's 2.4.21-47 kernel?
> 
> I've trying to modify the DHCP 3.0.1 code provided with RH 3 so I can  
> send requests via a PPP connection (standard RS-232), and it is just  
> being dropped by the stack according to ifconfig and debug statements  
> in ppp_generic.c.

I'm not sure what sort of "raw" packets you're talking about (IP raw
or something else), but you shouldn't need to send any raw packets to
do this.  DHCP runs over UDP, and, unlike Ethernet, there's no link
layer addressing to worry about.

-- 
James Carlson         42.703N 71.076W         <carlsonj@workingcode.com>
