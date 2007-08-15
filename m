Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbXHOHJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbXHOHJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXHOHJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:09:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43365 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbXHOHJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:09:23 -0400
Message-ID: <46C2A69F.6020004@garzik.org>
Date: Wed, 15 Aug 2007 03:09:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Correct IORDY handling
References: <20070731140148.4cb780de@the-village.bc.nu>
In-Reply-To: <20070731140148.4cb780de@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Debugging a report of a problem with an ancient solid state disk showed
> up some problems in the IORDY handling
> 
> 1.	We check the wrong bit to see if the device has IORDY
> 2.	Even then some ancient creaking piles of crap don't support
> 	SETXFER at all.
> 
> I think this should go via -mm for a bit. The cases it fixes are obscure
> and the risk of side effects is slight but possible. This also moves us
> slightly closer to supporting original MFM/RLL disks with libata but
> before Jeff panics I have no plans to do that....
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied


