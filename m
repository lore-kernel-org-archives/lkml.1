Return-Path: <linux-kernel-owner+w=401wt.eu-S1767217AbXEBXV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767217AbXEBXV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767223AbXEBXV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:21:26 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60293 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767217AbXEBXVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:21:25 -0400
Message-ID: <46391C54.5070503@gmail.com>
Date: Thu, 03 May 2007 01:18:44 +0200
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
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr> <4638FBB8.4020506@zytor.com> <4638FDA6.9030500@gmail.com> <4638FF70.8020400@zytor.com> <46390086.2030904@gmail.com> <463901C9.7090107@zytor.com> <46390503.1000401@gmail.com> <46390CA3.5030300@zytor.com> <46391590.8080209@gmail.com> <463917DD.8020500@zytor.com>
In-Reply-To: <463917DD.8020500@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2007 12:59 AM, H. Peter Anvin wrote:

> Rene Herman wrote:

>> Checking here, and mine also has 132x25 as BIOS mode 0x14 in addition to
>> 0x55. Probably also not universal, and 0x54 (132x43) doesn't seem to be
>> repeated. Unfortunate that Qemu/Bocks don't have the VESA text modes.
> 
> Does it export these modes though the VESA interface, or do you have to
> "select them blind?"

It also provides them as VESA modes yes. On further inspection, 0x14 is 
actually a bit different:

BIOS 0x14 =              132x25, 8x16 char cell on 1056x400
BIOS 0x54 = VESA 0x10A = 132x43, 8x8  char cell on 1056x350
BIOS 0x55 = VESA 0x109 = 132x25, 8x14 char cell on 1056x350

Booting 2.6.20.1 on the machine with vga=ask finds BIOS 0x14 as 0214 and 
VESA 0x10A as 030A but allows me to select 0254, 0255 and 0309 as well.
('scan' finds BIOS 0x14 as 0114 and BIOS 0x54 as 0154)

Rene.

