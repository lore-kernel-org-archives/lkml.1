Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYFEOzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYFEOzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYFEOzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:55:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbYFEOzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:55:04 -0400
Date: Thu, 5 Jun 2008 07:54:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5
In-Reply-To: <20080605150306.18c00bd9@Varda>
Message-ID: <alpine.LFD.1.10.0806050749570.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <20080605150306.18c00bd9@Varda>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jun 2008, Alejandro Riveira Fernández wrote:
>
>  I got this on my dmesg; is this expected/harmaless?
>  (btw The wireless driver oops that i reported is gone as it is the 
>  bluetooth one ;)
> 
..
> [    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
> [    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
.. repeated a lot ..

It's harmless but obviously irritating. The PnP resource manager changes 
need a few cleanups still - it's getting confused about IORESOURCE_UNSET 
vs IORESOURCE_DISABLED.

Björn?

		Linus
