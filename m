Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZHBQVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZHBQVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZHBQVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:21:52 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:51591 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907AbZHBQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:21:51 -0400
Message-ID: <4A75BD2A.9050404@vmware.com>
Date: Sun, 02 Aug 2009 18:22:02 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Use clflush() instead of wbinvd() whenever	possible
 when changing mapping
References: <1248421981-31865-1-git-send-email-thellstrom@vmware.com> <20090730090747.GD1364@ucw.cz>
In-Reply-To: <20090730090747.GD1364@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek skrev:
> On Fri 2009-07-24 09:53:01, Thomas Hellstrom wrote:
>   
>> The current code uses wbinvd() when the area to flush is > 4MB. Although this
>> may be faster than using clflush() the effect of wbinvd() on irq
>> latencies
>>     
>
> You are slowing the kernel down, and you did not write down the
> reasons. bad.
>
>   
I may slow the kernel down or speed it up depending on your hardware 
configuration. The reasons should be quite obvious if you read the 
discussion following the patch.

/Thomas

