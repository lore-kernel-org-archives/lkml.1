Return-Path: <linux-kernel-owner+w=401wt.eu-S1946623AbXBIR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946623AbXBIR4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946627AbXBIR4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:56:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:55207 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946623AbXBIR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:56:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=U95l5mzH5saBAHlptoPgwJjE3WRfQiARORteS2pkBHl1ioflvv/wXRU+cFAPOJ5sDh3HE2AoN/kgQxDmrk0l+o/L8T7fqmJERo7l7+QpvK8GqItLbFeVoEa4m8MHoDXVlKzS8tBH6pBqbWxEzlgS4rIOmYZI0go7Q6uvPrH60Fw=
Message-ID: <64d833020702090956oa30c9dfpbd752dad1313d606@mail.gmail.com>
Date: Fri, 9 Feb 2007 12:56:16 -0500
From: koan <koan00@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I believe you need to add the flag '-d ata' to the smartctl command in
order to see the smart status of a SATA device.

-Jesse

-------------------------------------------------------------
here it is:

-->

# smartctl -a /dev/sda
smartctl version 5.36 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce
Allen
Home page is http://smartmontools.sourceforge.net/

Device: ATA      WDC WD1500ADFD-0 Version: 20.0
Serial number:      WD-WMAP41246348
Device type: disk
Local Time is: Fri Feb  9 18:06:23 2007 CET
Device does not support SMART

Error Counter logging not supported

[GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
Device does not support Self Test logging

<--

cu,
 Emmy
