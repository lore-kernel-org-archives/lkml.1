Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZIPNoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZIPNoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZIPNoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:44:01 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48993 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752593AbZIPNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:44:00 -0400
Date: Wed, 16 Sep 2009 09:44:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
In-Reply-To: <200909161425.18729.volkerarmin@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0909160939230.8236-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Volker Armin Hemmann wrote:

> emm, the mouse is attached through a powered 4port usb 2.0 hub. That is the 
> only way to get it working. If I attach it directly (without loading ohci) it 
> does not work (well, only tried with both Transaction Translator options off), 
> and if I load ohci before I connect it, it is very very jerky. So jerky in 
> fact, that I considered douzends of lockups a day a better alternative.

That is a separate issue and it is a serious bug.  If anything, the 
behavior with OHCI should be better than with EHCI.  This is worth 
pursuing farther.  A usbmon log combined with the dmesg log would help.  
There's no need to include all the boot-up messages in the dmesg log; 
you can clear the log buffer before plugging in the mouse.

In fact, we can probably forget about the EHCI issue.  If it works okay 
with the newer TT scheduler, that should be good enough.

Alan Stern

