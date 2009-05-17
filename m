Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZEQNDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZEQNDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZEQNDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:03:30 -0400
Received: from www17.your-server.de ([213.133.104.17]:52253 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZEQNDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:03:30 -0400
Message-ID: <20090517150318.13801o5efb1taoeu@mail.your-server.de>
Date: Sun, 17 May 2009 15:03:18 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net,
       Robert Richter <robert.richter@amd.com>
Subject: Re: oprofile: WQ on CPU0, prefer CPU1
References: <20090514202214.14243n1debrzobx2@mail.your-server.de>
 <20090516224947.05067f96.akpm@linux-foundation.org>
In-Reply-To: <20090516224947.05067f96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von Andrew Morton <akpm@linux-foundation.org>:

> (cc's added, from MAINTAINERS)
>
> On Thu, 14 May 2009 20:22:14 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:
>
>>
>> After suspend and resume to/from S3 I see a lot of these messages in
>> the kernel log:
>>
>> [11750.054031] WQ on CPU0, prefer CPU1
>> [11750.154023] WQ on CPU0, prefer CPU1
>> [11750.254022] WQ on CPU0, prefer CPU1
>> [11750.354022] WQ on CPU0, prefer CPU1
>> [11750.454018] WQ on CPU0, prefer CPU1
>> [11750.554022] WQ on CPU0, prefer CPU1
>> [11750.654022] WQ on CPU0, prefer CPU1
>> [11750.754039] WQ on CPU0, prefer CPU1
>> [11750.854020] WQ on CPU0, prefer CPU1
>> [11750.954024] WQ on CPU0, prefer CPU1
>> [11751.054029] WQ on CPU0, prefer CPU1
>> [11751.154028] WQ on CPU0, prefer CPU1
>> [11751.254026] WQ on CPU0, prefer CPU1
>> [11751.354019] WQ on CPU0, prefer CPU1
>> [11751.454022] WQ on CPU0, prefer CPU1
>> [11751.554032] WQ on CPU0, prefer CPU1
>> [11751.654028] WQ on CPU0, prefer CPU1
>> [11751.754028] WQ on CPU0, prefer CPU1
>> [11751.854033] WQ on CPU0, prefer CPU1
>> [11751.954029] WQ on CPU0, prefer CPU1
>> [and so on; seems not to stop]
>>
>> This comes from drivers/oprofile/cpu_buffer.c
>>
>> Bug or feature?
>>
>
> Don't know.  It needs fixing though - the kernel shouldn't blurt random
> printks like this.
>
>>
>> PS: 2.6.30-rc5
>
> Do you know if earlier kernels did the same thing?

I don't know.


