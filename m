Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZD3C2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZD3C2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZD3C1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:27:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44431 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbZD3C1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:27:49 -0400
Message-ID: <49F90CA2.4080602@garzik.org>
Date: Wed, 29 Apr 2009 22:27:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
 question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org>
In-Reply-To: <E1LzLgA-0004j6-9W@closure.thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:

(you should cc linux-ide...)

> [ 4563.614247] ata4.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/32)
>                                                                 ^^^^^^^

That generally means your disk is capable of NCQ, but your controller is 
not.

As Tejun noted, try switching to AHCI mode in BIOS.

	Jeff



