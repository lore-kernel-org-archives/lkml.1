Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbXLXFqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbXLXFqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 00:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXLXFqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 00:46:46 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51534 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXLXFqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 00:46:45 -0500
Message-ID: <476F4064.8010601@in.ibm.com>
Date: Mon, 24 Dec 2007 10:45:16 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: linux-kernel@vger.kernel.org, ak@suse.de, jdmason@kudzu.us
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
 in kdump
References: <1191962414.24134.68.camel@chandru> <20071009210623.GK4335@rhun.haifa.ibm.com> <20071010053057.GA24434@in.ibm.com> <20071014054110.GB4399@rhun.haifa.ibm.com> <20071015062919.GA4598@in.ibm.com>
In-Reply-To: <20071015062919.GA4598@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Muli,

I have tried to work with CCR ,CSR, CSMR, CSAR, CFGRW, GBRERRM  
registers but have been unable to make calgary generate an exception 
upon error condition.  In alloc_tce_table() , I am setting WRITE_ONLY 
access permission bit to tce entries but it isn't helping.  Would you 
kindly let me know how we can make calgary to generate an exception in 
error conditions ?.

Thanks,
Chandru

