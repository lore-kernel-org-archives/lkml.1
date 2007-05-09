Return-Path: <linux-kernel-owner+w=401wt.eu-S1033705AbXEIDSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033705AbXEIDSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033206AbXEIDSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:18:42 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032936AbXEIDSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:18:41 -0400
Message-ID: <46413D87.3080400@zytor.com>
Date: Tue, 08 May 2007 20:18:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@osdl.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
References: <46413851.6070505@zytor.com> <46413A7E.5050304@garzik.org>
In-Reply-To: <46413A7E.5050304@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> H. Peter Anvin wrote:
>> Checkin 464bdd33e9baad9806c7adbd8dfc37081a55f27e "fbdev: ignore VESA
>> modes if framebuffer is disabled" is just plain wrong on any system
>> which has support for extended text modes in its VESA BIOS.
>>
>> Antonio is incorrectly assuming this branchout is used only to set VESA
>> graphics modes, but it's to set any VESA mode, be it text or graphics.
> 
> I wonder if this fbdev update is what causes my X session to die?
> 
> I'm using the VESA driver on my ATI R580, and just filed this bug report
> minutes ago: http://lkml.org/lkml/2007/5/8/667
> 

Perhaps, but not due to this partiular patch. :)

	-hpa
