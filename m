Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXBXHz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXBXHz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 02:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933418AbXBXHz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 02:55:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53001 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414AbXBXHz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 02:55:57 -0500
Message-ID: <45DFEF87.4050103@garzik.org>
Date: Sat, 24 Feb 2007 02:55:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Manuel Metz <mmetz@astro.uni-bonn.de>, studium@profihost.com,
       linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
References: <7G2pJ-2iX-23@gated-at.bofh.it> <7G828-3zn-3@gated-at.bofh.it>	<7HpWX-3D2-5@gated-at.bofh.it> <7Hrci-5ou-5@gated-at.bofh.it>	<7HrP4-6t8-1@gated-at.bofh.it> <7Hvzs-3Tj-23@gated-at.bofh.it>	<7IYJ1-281-27@gated-at.bofh.it>	<45D2CEFC.4010900@astro.uni-bonn.de> <45DC3345.5000804@gmail.com> <45DC7769.7030206@astro.uni-bonn.de> <45DFDA3E.80402@gmail.com>
In-Reply-To: <45DFDA3E.80402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Manuel Metz wrote:
>> Tejun Heo wrote:
>>> Does it work if you give 'irqpoll' kernel parameter?
>>>
>> Yes this works with "irqpoll". But as you can see in the attached dmesg
>> output, now I get a bunch of APIC errors ... ?
> 
> Manuel, Stefan, please try the attached patch over 2.6.20 and report the
> result.

Booting with 'pci=nomsi' should achieve the same effect...

	Jeff



