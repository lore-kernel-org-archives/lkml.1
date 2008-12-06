Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYLFMWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYLFMWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYLFMWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:22:00 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:37208 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYLFMV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hvVKryamqG5xsX7OxNnpH2Bw9Qb+sFxYJRhH3x0XfZNwfBDZeff9F4sD5bLhAkJaH4
         KADVGGPzRMhRpV26BLaLDICkjI+3ml8KdEKnefGxL4ThrF25DwcqtA5xGeyT/2YlVUpY
         OJAi8Bn8WoV0lmfErvSvtP85UHZTIxi+PKgE4=
Message-ID: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
Date: Sat, 6 Dec 2008 13:21:58 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [HW PROBLEM] Intel I7 MCE. Erratum or not?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
Mcelog just logged on my new Intel I7 920 (on Linux 2.6.27.8) this :
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 6 MISC 202d ADDR ffeef740
MCG status:
MCi status:
Error overflow
Uncorrected error
MCi_MISC register valid
MCi_ADDR register valid
Processor context corrupt
MCA: Generic CACHE Level-2 Data-Write Error
STATUS ee0000000100014a MCGSTATUS 0

I'm reporting this here, because I found in the Intel I7 Technical
Specification November 2008 update that something which seems very
similar is in fact an erratum. So my question is : Is there any way
for me to verify that my problem is due to one of those errata,instead
of a broken hardware(if we don't want to consider all those errata as
broken hardware)? I'm also reporting this because I thought it may be
useful to signal that(if actually due to those errata) these problems
actually occur, so it may be useful to find workarounds in the kernel
to not scare to death poor Linux users!

If you need more infos, just tell me.

Thanks,

Giangiacomo
