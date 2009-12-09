Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbZLIOlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbZLIOlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZLIOlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:41:04 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39420 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750926AbZLIOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:41:03 -0500
Date: Wed, 9 Dec 2009 09:41:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gertjan van Wingerde <gwingerde@gmail.com>
cc: Ivo van Doorn <IvDoorn@gmail.com>, <linux-wireless@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
In-Reply-To: <14add3d10912080648w5610d533h2cf08a9d79fa48c1@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0912090940030.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Gertjan van Wingerde wrote:

> Hmm, the stack overrun seems to be generated as part of the
> Alt-SysRq-* handling, not of any rt61pci handling.
> 
> I noticed in the Alt-SysRq-T output that powersaving is enabled. We've
> seen some strange behaviour on this, so could you disable that with:
> 
> iwconfig wlan0 power off
> 
> or run a kernel in which CONFIG_CFG80211_DEFAULT_PS is disabled.
> 
> Maybe that will fix the problem we are seeing?

It did indeed!  Thank you very much.  If you need a testbed to figure 
out what's wrong with the power-saving code, just ask.

Alan Stern

