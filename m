Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0BST4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:56:04 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:37059 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab0BST4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:56:00 -0500
Message-ID: <4B7EECB2.9090406@csr.com>
Date: Fri, 19 Feb 2010 19:55:30 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       =?UTF-8?B?UmljaGFyZCBSw7Zq?= =?UTF-8?B?Zm9ycw==?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Pierre Ossman <pierre@ossman.eu>, Ben Dooks <ben@simtec.co.uk>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sdhci: Implement CAP_CLOCK_BASE_BROKEN quirk
References: <20100219194827.GA16636@oksana.dev.rtsoft.ru>
In-Reply-To: <20100219194827.GA16636@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2010 19:55:31.0147 (UTC) FILETIME=[7DC429B0:01CAB19D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> Some hosts (e.g. as found in CNS3xxx SOCs) report wrong value in
> CLOCK_BASE capability field, and currently there is no way to
> force the SDHCI core to use the platform-provided base clock value.

I don't think this needs a new quirk. Change the sdhci driver to check
if the platform provides a value before reading the standard register.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
