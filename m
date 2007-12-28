Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXL1HeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXL1HeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXL1HeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:34:15 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54479 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbXL1HeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:34:14 -0500
Message-ID: <4774A6D2.9090300@ak.jp.nec.com>
Date: Fri, 28 Dec 2007 16:33:38 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@osdl.org, morgan@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com> <Xine.LNX.4.64.0712281748240.18737@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0712281748240.18737@us.intercode.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Fri, 28 Dec 2007, KaiGai Kohei wrote:
> 
>> +	snprintf(tmp, sizeof(tmp),
>> +		 cap_entry == &cap_entries[0] ? "0x%08x" :  "%u",
>> +		 cap_entry->code);
>> +	len = strlen(tmp);
> 
> You don't need to call strlen(), just use scnprintf() and grab the return 
> value.

Thanks for your suggestion,

I'll fix it on the next posting.
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
