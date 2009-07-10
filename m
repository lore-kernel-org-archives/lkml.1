Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZGJNV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZGJNV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZGJNVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:21:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:56507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbZGJNVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:21:17 -0400
Message-ID: <4A574049.5090708@kernel.org>
Date: Fri, 10 Jul 2009 22:21:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Christof Warlich <christof@warlich.name>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A52F39A.1030704@warlich.name>	 <4A5311C7.1020507@warlich.name> <4A535973.9090206@gmail.com>	 <4A5388EA.7030503@warlich.name> <4A53DA88.5080703@gmail.com>	 <4A543FA5.1090608@warlich.name> <4A54AD1A.1040009@kernel.org>	 <4A54B98B.50806@gmail.com> <4A56344C.3010500@warlich.name> <51f3faa70907091631s329255en5fc197091b9ae4f0@mail.gmail.com>
In-Reply-To: <51f3faa70907091631s329255en5fc197091b9ae4f0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 13:21:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert Hancock wrote:
> On Thu, Jul 9, 2009 at 12:17 PM, Christof Warlich<christof@warlich.name> wrote:
>> Just one clarification: From what I understood so far, it will be impossible
>> to ever utilize the full disk capacity as long as the BIOS applies the HPA
>> on boot, right?
> 
> I believe that's the case, yes.. if the BIOS is applying the HPA on
> each boot, then we can't change the max address again without a
> hardware reset..

This is one of the reasons why libata was switched to prefer hardreset
so that BIOS lock downs can be circumvented.  PATA drivers
unfortunately usually don't implement hardreset.  :-(

I'll forward the patch upstream.

Thanks.

-- 
tejun
