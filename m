Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYIYLMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYIYLMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYIYLM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:12:28 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:53107 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbYIYLM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:12:27 -0400
Date: Thu, 25 Sep 2008 13:12:40 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27-rc7 no init found on the root partition?
Message-ID: <20080925111239.GF31582@ics.muni.cz>
References: <20080924192227.GC31582@ics.muni.cz> <20080924230326.GM5448@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080924230326.GM5448@disturbed>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 25 Sep 2008 13:12:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 09:03:26AM +1000, Dave Chinner wrote:
> On Wed, Sep 24, 2008 at 09:22:27PM +0200, Lukas Hejtmanek wrote:
> > Hello,
> > 
> > I have a box that has XFS root partition, I have kernel 2.6.26.3 that boots
> > pretty well on that box. Today, I've tried 2.6.27-rc7 (so that I can test
> > NFSv4 over IPv6), but the kernel is unable to boot. It says that root
> > partition is mounted, XFS file system but no init found.
> 
> Can you paste the error messages or send pointers to screen shots of
> the error?

http://undomiel.ics.muni.cz/tmp/IMG_2962.JPG

this one is if I pass init=/bin/bash
http://undomiel.ics.muni.cz/tmp/IMG_2961.JPG

> If you go back to 2.6.26.3, does the kernel boot ok?

indeed.


this is a grub record:

title Linux 2.6.26.3
root (hd0,0)
kernel /boot/vmlinuz-2.6.26.3 root=/dev/sda1 ro console=tty0

title Linux 2.6.27-rc7
root (hd0,0)
kernel /boot/vmlinuz-2.6.27-rc7 root=/dev/sda1 ro 


-- 
Luká¹ Hejtmánek
