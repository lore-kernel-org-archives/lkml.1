Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYEOWXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYEOWXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYEOWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:23:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYEOWXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:23:20 -0400
Message-ID: <482CB7D7.30008@redhat.com>
Date: Thu, 15 May 2008 18:23:19 -0400
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>
Subject: Re: [PATCH] PCI: Correct last two HP entries in the bfsort whitelist
References: <482C838E.3030203@redhat.com> <20080515220215.76eea915@core>
In-Reply-To: <20080515220215.76eea915@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> This is going to make everyone with those boxes who upgrades suddenely
> get their devices re-ordered and renamed when the probe order changes.
> That seems extremely inappropriate.
> 
> Alan

HP maintains that more of our customers, especially new customers,
will be adversely affected by NOT implementing this patch for the
following reasons.

1. HP issued a Customer Advisory for existing customers to use "pci=bfsort"
    in the boot command for these systems. Customers using pci=bfsort in
    their boot scripts will be unaffected by this patch.

2. Customers using only the two embedded NI devices will be unaffected.

3. Because of the use of labels for disk devices, they are unaffected.

4. New customers who must add pci=bfsort to their boot scripts have
    expressed dissatisfaction.

The only time this patch would induce any confusion for an existing customer
is upon the convergence of the following situations.

1. The user has not followed the instructions in the release notes
    for the DL360 and DL380,

    AND

2. The user has added NI cards to the option slots,

    AND

3. The user upgrades his kernel.



