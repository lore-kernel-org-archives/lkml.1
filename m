Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYJWDdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYJWDdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 23:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYJWDdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 23:33:38 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57511 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbYJWDdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 23:33:37 -0400
Message-ID: <48FFF08C.5040802@linux.vnet.ibm.com>
Date: Thu, 23 Oct 2008 09:03:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       emil.s.tantilov@intel.com
Subject: Re: [PANIC] 2.6.28-git panics in mem_cgroup_charge_common called
 by ext3
References: <Pine.WNT.4.63.0810221308230.3204@jbrandeb-desk.amr.corp.intel.com>
In-Reply-To: <Pine.WNT.4.63.0810221308230.3204@jbrandeb-desk.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brandeburg, Jesse wrote:
> In doing some other testing on yesterday's git 
> 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4
> we just ran across this:
> 
> this mail contains:
> panic message
> lspci -vvv
> .config
> dmesg before crash
> 
> how to reproduce:
> just find / or ls -lR /
> 


Thanks for the bug report. We've fixed the problem, the fix can be found at

http://marc.info/?l=linux-mm-commits&m=122463950706923&w=2
http://marc.info/?l=linux-mm-commits&m=122463952606930&w=2
http://marc.info/?l=linux-mm-commits&m=122466045532477&w=2

The final fix has been pushed to linus.

-- 
	Balbir
