Return-Path: <linux-kernel-owner+w=401wt.eu-S1161782AbXEBVXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161782AbXEBVXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161784AbXEBVXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:23:04 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:47155 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161782AbXEBVXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:23:03 -0400
Message-ID: <46390086.2030904@gmail.com>
Date: Wed, 02 May 2007 23:20:06 +0200
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
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr> <4638FBB8.4020506@zytor.com> <4638FDA6.9030500@gmail.com> <4638FF70.8020400@zytor.com>
In-Reply-To: <4638FF70.8020400@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2007 11:15 PM, H. Peter Anvin wrote:

> However, the pluggable framework is quite trivial and makes the code
> look really clean, so I'm keeping it regardless.

Sheesh. Anyways, I know you asked about register writes but in case it's 
still useful info: the CL54xx adapters have 132x43 and 132x25 as BIOS modes 
0x54 and 0x55 (ie, just int 0x10 modes) respectively. No idea how complete 
the Bochs/Qemu video BIOS is.

Rene.

