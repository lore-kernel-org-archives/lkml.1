Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZBUEoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZBUEoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 23:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZBUEn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 23:43:58 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:39857 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZBUEn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 23:43:58 -0500
Message-ID: <499F869C.9000208@oracle.com>
Date: Fri, 20 Feb 2009 20:44:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, JosephChan@via.com.tw
Subject: Re: mmotm 2009-02-20-15-52 uploaded (via-sdmmc)
References: <200902210010.n1L0ADsO010055@imap1.linux-foundation.org>
In-Reply-To: <200902210010.n1L0ADsO010055@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.499F8663.00DC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-02-20-15-52 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.29-rc5:
> 

> via-sdmmc-via-msp-card-reader-driver-support.patch


when CONFIG_PM=n:

drivers/mmc/host/via-sdmmc.c:336: error: 'struct via_crdr_chip' has no member named 'pm_pcictrl_reg'
drivers/mmc/host/via-sdmmc.c:355: error: 'struct via_crdr_chip' has no member named 'pm_pcictrl_reg'
drivers/mmc/host/via-sdmmc.c:372: error: 'struct via_crdr_chip' has no member named 'pm_sdhc_reg'
drivers/mmc/host/via-sdmmc.c:392: error: 'struct via_crdr_chip' has no member named 'pm_sdhc_reg'

-- 
~Randy
