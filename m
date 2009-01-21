Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZAUANr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZAUANr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZAUANi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:13:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36221 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZAUANh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:13:37 -0500
Message-ID: <4976688B.4050309@jp.fujitsu.com>
Date: Wed, 21 Jan 2009 09:12:59 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH PCI PCIe portdrv: Fix allocation of interrupts (rev. 5)
References: <200901131457.58164.rjw@sisk.pl> <200901171440.42840.rjw@sisk.pl> <4973F60E.5000706@jp.fujitsu.com> <200901210057.12103.rjw@sisk.pl>
In-Reply-To: <200901210057.12103.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
[snip]
>> 	/*
>> 	 * World have broken hardwares, so even spec says numbers are constant,
>> 	 * it would be better to re-check registers after 2nd pci_enable_msix.
>> 	 * Or we just skip this.  (However this was what your concern, Rafael?)
>> 	 */
>> 	if (func_foo_do_paranoia_check(dev, msix_entries, nvec))
>> 		goto Error;	
> 
> Well, I think let's not do it for now.  If there's a system that actually
> breaks here, then we can introduce the extra checking.
> 

Agreed.

Thanks,
Kenji Kaneshige


