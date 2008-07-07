Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYGGVgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYGGVgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYGGVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:36:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:28019 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbYGGVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=MfzVq+hrEBbgVUUwzQCbR1946p4o/OvgganSkoMTAqWRwPZ3R1v+FK4b2eEvNNNe1n
         g3WuN4FB9VxNHeIek4xmUYsK6o0f/ZMhGf+dqLYTQ9yPhwBlbng9Y5XWw7LTiCRfjMBl
         erx4wko209WCQ0DmEdbbsXRw6YZqoovfvjx+M=
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:44:07 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Bauer <stefan-a-bauer@gmx.net>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072327.17714.stefan-a-bauer@gmx.net>
In-Reply-To: <200807072327.17714.stefan-a-bauer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072344.07580.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008, Stefan Bauer wrote:
> Am Montag, 7. Juli 2008 schrieb Stefan Bauer:
> 
> > dmesg 2.6.26-rc9
> > ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
> > phy0: Selected rate control algorithm 'pid'
> > phy0: Failed to initialize wep
> > phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
> > rt2500pci: probe of 0000:00:0c.0 failed with error -12
> >
> > .config 2.6.26-rc9
> > <http://www-user.tu-chemnitz.de/~stefb/rt2500pci/config>
> >
> > Next I'm going to test 2.6.24 and 2.6.25 to check whether it's an
> > regression or not.
> 
> Same problem with 2.6.24.7, I'll skip 2.6.25.

What happens when you compile ecb and arc4 into the kernel
instead as seperate modules?

Ivo
