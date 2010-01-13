Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025Ab0AMWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0AMWhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757Ab0AMWho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:37:44 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:57389 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab0AMWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:37:43 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: task imap:2958 blocked for more than 120 seconds
Date: Wed, 13 Jan 2010 23:37:33 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc2-00302-gc5974b8-dirty; KDE/4.3.90; x86_64; ; )
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de> <20100110201926.GC32195@think>
In-Reply-To: <20100110201926.GC32195@think>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001132337.34909.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 10 Januar 2010 21:19:26 schrieb Chris Mason:
> On Sun, Jan 10, 2010 at 09:05:46PM +0100, Johannes Hirte wrote:
> > I've observed this hanging task now several times. Not sure when this
> > started, but 2.6.32 is affected too, IIRC. I don't have a test pattern
> > for this. Dovecot imap triggers this from time to time. I've enabled
> > CONFIG_DETECT_HUNG_TASK now
> 
> > and got this two tasks which hang:
> You're stuck on a read, could you please do a sysrq-w when this happens?

Will do so when it happens again.

> Also, do you eventually recover or are you stuck forever?

I didn't wait too long when it happened, so I'm not sure.  The longest time 
I've waited was 20-30min, until reboot without recover. So either it's stuck 
forever or it takes really long to recover.

And one question I have: How do you identify a read in this call trace? 

regards,
  Johannes
