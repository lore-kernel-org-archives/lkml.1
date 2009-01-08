Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbZAHMS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbZAHMS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZAHMSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:18:51 -0500
Received: from mout-xforward.kundenserver.de ([212.227.17.5]:57750 "EHLO
	mout-xforward.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbZAHMSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:18:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dick Hollenbeck <dick@softplc.com>
Subject: Re: New true IDE compact flash driver starting point?
Date: Thu, 8 Jan 2009 13:18:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <49659E41.5070001@softplc.com>
In-Reply-To: <49659E41.5070001@softplc.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081318.44188.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Izx3oiT6HgIOD2BQpTGEe0Z9odM6zfJ/S3q7
 nH3eQhlS7WbyS1lyTX7fF6uUhdDtP6ibrRTN6WKUvSJ+VKhvrW
 /Hj7Ko4zXLNvvzJG20VqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Dick Hollenbeck wrote:
> On a new ARM9 board with memory mapped interface to a compact flash 
> socket, I need to implement an IDE or ATA driver that will support TRUE 
> IDE mode.
> 
> Am using kernel version 2.6.26
> 
> What is the best starting point, i.e. example driver in the tree?

You should not need to write a new driver, but rather use the existing
drivers/ata/pata_platform.c driver by registering the MMIO registers
and IRQ number as a platform device.

	Arnd <><
