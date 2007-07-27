Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXG0VFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXG0VFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762425AbXG0VFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:05:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33072 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764277AbXG0VFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:05:36 -0400
Message-ID: <46AA5E1A.8020303@garzik.org>
Date: Fri, 27 Jul 2007 17:05:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707271256.17025.bjorn.helgaas@hp.com> <86802c440707271335y29ca79ccq844b5cb457bd2314@mail.gmail.com> <200707271458.44391.bjorn.helgaas@hp.com>
In-Reply-To: <200707271458.44391.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> And couldn't we use udev to associate a fixed name with a MAC
> address?  Then the user could use the same persistent name,
> regardless of the order in which the driver found the devices.


I don't know about udev, but people are definitely using fixed names 
based on MAC address for ethernet devices already:  nameif(8) and 
/etc/mactab, iftab(5) and ifrename(8).

	Jeff


