Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbXBZIcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbXBZIcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 03:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933800AbXBZIcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 03:32:50 -0500
Received: from aibn55.astro.uni-bonn.de ([131.220.96.55]:49356 "EHLO
	aibn55.astro.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798AbXBZIct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 03:32:49 -0500
Message-ID: <45E29B1D.2050609@astro.uni-bonn.de>
Date: Mon, 26 Feb 2007 09:32:29 +0100
From: Manuel Metz <mmetz@astro.uni-bonn.de>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Tejun Heo <htejun@gmail.com>, studium@profihost.com,
       linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
References: <7G2pJ-2iX-23@gated-at.bofh.it>	<7G828-3zn-3@gated-at.bofh.it>	<7HpWX-3D2-5@gated-at.bofh.it>	<7Hrci-5ou-5@gated-at.bofh.it>	<7HrP4-6t8-1@gated-at.bofh.it>	<7Hvzs-3Tj-23@gated-at.bofh.it>	<7IYJ1-281-27@gated-at.bofh.it>	<45D2CEFC.4010900@astro.uni-bonn.de>	<45DC3345.5000804@gmail.com>	<45DC7769.7030206@astro.uni-bonn.de> <45DFDA3E.80402@gmail.com> <45DFEF87.4050103@garzik.org>
In-Reply-To: <45DFEF87.4050103@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This works fine now. I tried the kernel option, but have not tried the
patch.

Manuel

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Manuel Metz wrote:
>>> Tejun Heo wrote:
>>>> Does it work if you give 'irqpoll' kernel parameter?
>>>>
>>> Yes this works with "irqpoll". But as you can see in the attached dmesg
>>> output, now I get a bunch of APIC errors ... ?
>>
>> Manuel, Stefan, please try the attached patch over 2.6.20 and report the
>> result.
> 
> Booting with 'pci=nomsi' should achieve the same effect...
> 
>     Jeff
> 
> 

-- 
---------------------------------------
  Manuel Metz  ............  Stw@AIfA
  Argelander Institut fuer Astronomie
  Auf dem Huegel 71 (room 3.06)
  D - 53121 Bonn

  E-Mail: mmetz@astro.uni-bonn.de
  Web:    www.astro.uni-bonn.de/~mmetz
  Phone:  (+49) 228 / 73-3660
  Fax:    (+49) 228 / 73-3672
---------------------------------------
