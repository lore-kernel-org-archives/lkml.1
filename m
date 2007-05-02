Return-Path: <linux-kernel-owner+w=401wt.eu-S1766977AbXEBVPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766977AbXEBVPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423508AbXEBVPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:15:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35590 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423524AbXEBVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:15:43 -0400
Message-ID: <4638FF70.8020400@zytor.com>
Date: Wed, 02 May 2007 14:15:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr> <4638FBB8.4020506@zytor.com> <4638FDA6.9030500@gmail.com>
In-Reply-To: <4638FDA6.9030500@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 05/02/2007 10:59 PM, H. Peter Anvin wrote:
> 
>> I'm having a framework for multiple drivers (probe and set methods,
>> basically); the stock distro will have VGA and VESA drivers only.
>> Dropping new drivers in is trivial if someone wants to.
> 
> It sounds like going overboard a bit; 80x25 standard VGA, 80x43/50 line
> VGA (settable through simple BIOS calls) and VESA (80x60,
> 132x25/43/50/60) is all that anyone wants. If Bochs and Qemu emulata a
> CL54xx, they'll provide a VESA BIOS for it as well, I suppose?

Yes, but like most other VESA BIOSen they don't have any support for
extended text modes in their BIOS (they could add it, presumably.)

However, the pluggable framework is quite trivial and makes the code
look really clean, so I'm keeping it regardless.

	-hpa
