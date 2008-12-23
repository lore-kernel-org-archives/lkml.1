Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbYLWXfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbYLWXfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 18:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYLWXfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 18:35:30 -0500
Received: from main.gmane.org ([80.91.229.2]:49716 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYLWXf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 18:35:29 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] pci-quirks: Unhide 'Overflow' device on i828{6,7}5P/PE
 chipsets
Date: Tue, 23 Dec 2008 17:35:14 -0600
Message-ID: <495175B2.60307@shaw.ca>
References: <20081223215030.GA32525@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-pci@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <20081223215030.GA32525@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha³ Miros³aw wrote:
> As I found out from EDAC driver sources for i82875P some BIOSes for
> i82875P/PE hide 'overflow' device 6. The same thing happens for
> i82865P/PE chipsets.
> 
> After testing this patch for couple of days on my laptop (i82856P)
> it looks like something is resetting device 0 (MCH) config register
> 0xF4 to zero and effectively disabling the device again. The delay
> looks random to me. I can easily update the register using
> 'hexedit /sys/bus/pci/devices/0000\:00\:00.0/config' and see
> correct values in lspci output afterwards.

Could be the BIOS is using the device in SMI code or something (and 
that's what disables it), therefore it may be unsafe to unhide this device.

