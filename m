Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXBSRDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXBSRDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbXBSRDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:03:03 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:38471 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbXBSRDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:03:00 -0500
Message-ID: <45D9D848.4010608@drzeus.cx>
Date: Mon, 19 Feb 2007 18:03:04 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Racy NLS behaviour in FAT (and possible other fs)
References: <45D9C80A.2030905@drzeus.cx> <87tzxim6ic.fsf@duaron.myhome.or.jp>
In-Reply-To: <87tzxim6ic.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
>> I'm experiencing a rather odd behaviour with the character set
>> conversion. If I mount a vfat fs with utf8 and then create a file
>> with invalid utf-8 sequences, the file will briefly exist with these
>> invalid sequences, then quickly convert to a stripped version.
>>     
>
> Yes. utf8 support is broken, and it will fail to convert letter case
> on many case. And it's why that is not recommended.
>
>   

Is there any ongoing work to fix this? UTF-8 is standard on more or less
every distribution these days.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

