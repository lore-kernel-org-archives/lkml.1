Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXHAS2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXHAS2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbXHAS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:27:57 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:47229 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753374AbXHAS14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:27:56 -0400
Message-ID: <46B0D0B6.50208@cfl.rr.com>
Date: Wed, 01 Aug 2007 14:28:06 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "Hendrik ." <chasake@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Reading a bad sector does not report failure as 'read error'
 but hangs PC with 'Machine Check Exception'
References: <324190.80672.qm@web52009.mail.re2.yahoo.com>
In-Reply-To: <324190.80672.qm@web52009.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2007 18:28:08.0823 (UTC) FILETIME=[B5B04070:01C7D469]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15336.000
X-TM-AS-Result: No--7.444300-5.000000-4
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hendrik . wrote:
> So I think there is a problem with this specific CK804
> ATA controller causing the MCE... Any clues?

Yes, the SATA chip is broken.  Probably time to check the known errata 
on the chip, and if it isn't known, bring nvidia in to debug their 
silicon.

