Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYJVNas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYJVNas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYJVNak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:30:40 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58646 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752245AbYJVNaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:30:39 -0400
Date: Wed, 22 Oct 2008 15:30:32 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Simen Thoresen <simentt@dolphinics.no>
cc: linux-kernel@vger.kernel.org
Subject: Re: File as generic block-device?
In-Reply-To: <48FF2304.8070301@dolphinics.no>
Message-ID: <Pine.LNX.4.64.0810221529200.29342@vixen.sonytel.be>
References: <48FF2304.8070301@dolphinics.no>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-369450091-1224682232=:29342"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-369450091-1224682232=:29342
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 22 Oct 2008, Simen Thoresen wrote:
> I have a project where I require to treat a file as a block-device
> (specifically, I want a file on an ext3 fs to act as one of the raid-members
> in a md-based stripe-set. I know that I can make a /filesystem/ on a file
> because both mkfs and mount (with -o loop) will accept a file as a
> block-device, but I have found no such function for mdadm, and am thus asking
> for a kernel-internal way to re-plug a file into the block-device layer.
> 
> Is this possible?

Sure! You just have to create the loop device (/dev/loop*) yourself using
losetup(8). `mount -o loop' does it itself behind your back.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-369450091-1224682232=:29342--
