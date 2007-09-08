Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXIHQun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXIHQun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXIHQue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:50:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21752 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXIHQud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:50:33 -0400
Date: Sat, 8 Sep 2007 09:50:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-Id: <20070908095008.08eb4930.randy.dunlap@oracle.com>
In-Reply-To: <p73fy1p9m57.fsf@bingen.suse.de>
References: <20070907124800.GP16806@vanheusden.com>
	<p73fy1p9m57.fsf@bingen.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08 Sep 2007 18:07:00 +0200 Andi Kleen wrote:

> Folkert van Heusden <folkert@vanheusden.com> writes:
> 
> > Hi,
> > 
> > Maybe it is a nice enhancement for make menuconfig to more explicitly
> > give a pop-up or so when someone selects for example a sata controller
> > while no 'scsi-disk' support was selected?
> 
> This has also bitten me one or two times. A reasonable way would
> be to just select SD automatically for !EMBEDDED
> 
> Here's a patch:
> 
> -Andi
> 
> Select BLK_DEV_SD for all SCSI/libata drivers
> 
> This avoid a common user mistake.

I'd say that someone needs to use a vendor kernel, or at least
begin with a vendor .config file...


> Signed-off-by: Andi Kleen <ak@suse.de>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
