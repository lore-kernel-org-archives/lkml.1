Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXE1NLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXE1NLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbXE1NK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:10:58 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:59531 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbXE1NK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:10:57 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070528130030.GJ18807@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl> <20070528111554.GF18807@elf.ucw.cz> <1180351493.4242.31.camel@lov.localdomain> <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk> <1180353095.4242.57.camel@lov.localdomain> <BDEF3C8A-D237-44C4-84E0-2218DFAE0E77@cam.ac.uk> <20070528130030.GJ18807@elf.ucw.cz>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A19B5FA5-0DF4-4B8D-957C-3D6FB3485C30@cam.ac.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 14:10:52 +0100
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 14:00, Pavel Machek wrote:

> I'm too lazy to figure out how it currently works, but
> I'll just state it is not my fault

Figuring out how a userspace/kernelspace interface works should not  
rely on having to read kernelspace code. Unfortunately, in the case  
of hotplug / uevents, there is no such documentation. Thus, what  
kernelspace / userspace interactions actually are and what they  
should be is unclear, leading to confusion over corner cases, such as  
this one.

Michael-Luke Jones
