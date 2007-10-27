Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbXJ0OO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbXJ0OO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXJ0OOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:14:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50718 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbXJ0OOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:14:49 -0400
Message-ID: <472347D4.8070703@anagramm.de>
Date: Sat, 27 Oct 2007 16:14:44 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chris Holvenstot <cholvenstot@comcast.net>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Major SATA / EXT3 Issue?
References: <1193451712.6639.13.camel@localhost>
In-Reply-To: <1193451712.6639.13.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19fzJppMjrIMbhy25Wr8QT33CPuyVtBUrMQNbz
 9o6dlPDEoWPrd8RzfV6Yi+q5glYxM5Bqv09MFjV4guUpqD6x/5
 FJ3OwWzm2zSagfiLxldfA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Holvenstot schrieb:
> I am curious if anyone else has had major problems with SATA drives on
> the current series of kernels.  I have (or rather had) two SATA drives
> on my system - the first was a Maxtor MaxLine 500 and the second was a
> Maxtor MaxLine 250.
> [...]

If harddisks get too hot they die pretty quickly.
The current harddisks usually support SMART. Ask the disks what
they think it's wrong:
http://smartmontools.sourceforge.net/

Then, check the disks with different hardware... I have seen
several issues with bad cables and broken hardware.

If you think that the problem is kernel related, you can boot
some other distro or change the kernel to see if this problem
still persists. Please post the dmesg output if you are sure
the problem is kernel related...

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
