Return-Path: <linux-kernel-owner+w=401wt.eu-S1765860AbZDJSFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765860AbZDJSFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938824AbZDJSFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:05:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935337AbZDJSFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:05:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/6] x86, setup: "glove box" BIOS interrupts
Date: Fri, 10 Apr 2009 20:05:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <49DE7F79.4030106@zytor.com>
In-Reply-To: <49DE7F79.4030106@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904102005.32574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009, H. Peter Anvin wrote:
> This is a patchset to "glove box" off BIOS interrupts in the x86 setup
> code, thus hopefully dealing once and for all with the problems of
> BIOSes touching registers they shouldn't.
> 
> The concept is simple: we manipulate a register image in memory, then
> swap it in immediately before calling the BIOS, and then switch the
> register file back.  All BIOS interrupts are channeled through this path.
> 
> The increase in size is about 8% or ~1.3K in the maximal case.

FWIW, I like the approach.

Thanks,
Rafael
