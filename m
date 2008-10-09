Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYJIPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYJIPGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYJIPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:06:11 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53972 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbYJIPGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:06:10 -0400
Date: Thu, 9 Oct 2008 18:06:09 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: panic while doing lots of IO on lpfc
In-Reply-To: <Pine.SOC.4.64.0810091737430.5106@math.ut.ee>
Message-ID: <Pine.SOC.4.64.0810091804290.5106@math.ut.ee>
References: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee>
 <200810101233.18726.nickpiggin@yahoo.com.au> <Pine.SOC.4.64.0810091737430.5106@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Will try netconsole after haveing finished the same test with Qlogic 
> HBA.

With qla2100 it has problems too - the 'cat' that reads from SATA 
partitsion hangs in R state and is not killable with kill -9.

So it does not seem to be lpfc specific.

Will try netconsole next to capture more information.

-- 
Meelis Roos (mroos@linux.ee)
