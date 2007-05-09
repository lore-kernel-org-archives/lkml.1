Return-Path: <linux-kernel-owner+w=401wt.eu-S1033456AbXEIDFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033456AbXEIDFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032505AbXEIDFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:05:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39399 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032489AbXEIDFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:05:43 -0400
Message-ID: <46413A7E.5050304@garzik.org>
Date: Tue, 08 May 2007 23:05:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@osdl.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
References: <46413851.6070505@zytor.com>
In-Reply-To: <46413851.6070505@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Checkin 464bdd33e9baad9806c7adbd8dfc37081a55f27e "fbdev: ignore VESA
> modes if framebuffer is disabled" is just plain wrong on any system
> which has support for extended text modes in its VESA BIOS.
> 
> Antonio is incorrectly assuming this branchout is used only to set VESA
> graphics modes, but it's to set any VESA mode, be it text or graphics.

I wonder if this fbdev update is what causes my X session to die?

I'm using the VESA driver on my ATI R580, and just filed this bug report 
minutes ago: http://lkml.org/lkml/2007/5/8/667

	Jeff


