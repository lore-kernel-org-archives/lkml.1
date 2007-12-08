Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXLHEWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXLHEWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXLHEWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:22:17 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37361 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbXLHEWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:22:16 -0500
Message-ID: <475A1BEE.2050109@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 09:52:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Kumar Gala <galak@kernel.crashing.org>, Olof Johansson <olof@lixom.net>,
       linuxppc-dev@ozlabs.org, magnus.damm@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net> <4759BCA2.1020809@linux.vnet.ibm.com> <975B5B2B-C1F3-4021-9AE2-8873FFE1BDEC@kernel.crashing.org> <4759C548.6030304@linux.vnet.ibm.com> <alpine.DEB.0.9999.0712071508460.27689@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.9999.0712071508460.27689@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Sat, 8 Dec 2007, Balbir Singh wrote:
> 
>> To be able to test the memory controller under NUMA, I use fake NUMA
>> nodes. x86-64 has a similar feature, the code I have here is the
>> simplest I could come up with for PowerPC.
>>
> 
> Magnus Damm had patches from over a year ago that, I believe, made much of 
> the x86_64 fake NUMA code generic so that it could be extended for 
> architectures such as i386.  Perhaps he could resurrect those patches if 
> there is wider interest in such a tool.

That would be a very interesting patch, but what I have here is the
simplest patch and we could build on it incrementally. The interface is
non-standard but it does amazing things for 59 lines of code change.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
