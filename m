Return-Path: <linux-kernel-owner+w=401wt.eu-S2993163AbXEBVKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993163AbXEBVKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767021AbXEBVKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:10:25 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:50749 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993163AbXEBVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:10:20 -0400
Message-ID: <4638FDA6.9030500@gmail.com>
Date: Wed, 02 May 2007 23:07:50 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr> <4638FBB8.4020506@zytor.com>
In-Reply-To: <4638FBB8.4020506@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2007 10:59 PM, H. Peter Anvin wrote:

> I'm having a framework for multiple drivers (probe and set methods,
> basically); the stock distro will have VGA and VESA drivers only.
> Dropping new drivers in is trivial if someone wants to.

It sounds like going overboard a bit; 80x25 standard VGA, 80x43/50 line VGA 
(settable through simple BIOS calls) and VESA (80x60, 132x25/43/50/60) is 
all that anyone wants. If Bochs and Qemu emulata a CL54xx, they'll provide a 
VESA BIOS for it as well, I suppose?

Rene.

