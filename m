Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbZGXA0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbZGXA0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZGXA0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:26:10 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38920 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZGXA0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:26:10 -0400
Message-ID: <4A68FD3B.7040606@ct.jp.nec.com>
Date: Fri, 24 Jul 2009 09:15:55 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] move binfmt filed to signal_struct
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com>
In-Reply-To: <20090723161806.GA5690@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 07/22, Roland McGrath wrote:
>>>> Because the binfmt is not different between threads in the same process,
>>>> it can be moved from task_struct to signal_struct.
>>> Seems like a logical cleanup to me.
>> IMHO binfmt belongs in mm_struct.
> 
> Ah, agreed.
> 
> Hiroshi, what do you think?

yeah, it sounds better. I'll try to update.

Thanks,
Hiroshi
