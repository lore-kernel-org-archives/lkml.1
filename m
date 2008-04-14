Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbYDNAJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbYDNAJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYDNAIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:08:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38179 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbYDNAIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:08:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86 git tree broken (bisected)
Date: Mon, 14 Apr 2008 02:09:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <200804102159.14563.rjw@sisk.pl> <200804140141.45830.rjw@sisk.pl> <48029B04.9010108@zytor.com>
In-Reply-To: <48029B04.9010108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140209.28755.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > 
> > Well, unfortunately current x86.git doesn't even boot on the affected box.
> > It 'cannot open root device "md1" or unknown-block (0,0)' (Ingo, any ideas?).
> > 
> > Today I have to take some sleep, so I'll try to debug it tomorrow, unless
> > someone else does it earlier.
> > 
> 
> Sounds like you didn't compile in the appropriate RAID support...

In fact I did, but I didn't notice that the initrd image was not built
correctly due to a local error.

Thanks,
Rafael
