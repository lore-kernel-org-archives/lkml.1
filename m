Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbZD1QEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbZD1QEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbZD1QDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:03:09 -0400
Received: from oz.embeddedarm.com ([67.40.67.44]:62712 "EHLO
	oz.embeddedARM.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbZD1QDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:03:07 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 12:03:06 EDT
Message-ID: <49F7280C.5060709@embeddedarm.com>
Date: Tue, 28 Apr 2009 09:00:12 -0700
From: Eddie Dawydiuk <eddie@embeddedarm.com>
Organization: Technologic Systems
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: buytenh@gnu.org, linux-kernel@vger.kernel.org
Subject: Marvell 88F6281 Reference design
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (oz.embeddedARM.com [192.168.0.11]); Tue, 28 Apr 2009 08:56:44 -0700 (MST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a Marvell 88F6281 Reference design board I'm trying to compile a 2.6.28 
kernel for. Although, the machine id check is failing. The error is as follows

Uncompressing 
Linux.............................................................................................................................
. done, booting the kernel.

Error: unrecognized/unsupported machine ID (r1 = 0x0000020f).

Available machine support:

ID (hex)        NAME
00000690        Marvell DB-88F6281-BP Development Board
00000691        Marvell RD-88F6192-NAS Development Board
00000692        Marvell RD-88F6281 Reference Board

Please check your kernel config and/or bootloader.

I'm going to comment out this check temporarily(arch/arm/head.S), but wanted to 
notify you of this...

Please CC me personally with any responses.

-- 
Best Regards,
________________________________________________________________
  Eddie Dawydiuk, Technologic Systems | voice:  (480) 837-5200
  16525 East Laser Drive 	     | fax:    (480) 837-5300
  Fountain Hills, AZ 85268            | web: www.embeddedARM.com
