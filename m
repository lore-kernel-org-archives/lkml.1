Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbYART7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbYART7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758982AbYART7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:59:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45282 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760724AbYART7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:59:43 -0500
Message-ID: <4791052C.3090507@sgi.com>
Date: Fri, 18 Jan 2008 11:59:40 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
References: <20080118183011.354965000@sgi.com> <20080118183011.527888000@sgi.com> <Pine.LNX.4.64.0801182055190.15604@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801182055190.15604@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 18 2008 10:30, travis@sgi.com wrote:
>> --- a/include/linux/numa.h
>> +++ b/include/linux/numa.h
>> @@ -10,4 +10,10 @@
>>
>> #define MAX_NUMNODES    (1 << NODES_SHIFT)
>>
>> +#if MAX_NUMNODES > 256
>> +typedef u16 numanode_t;
>> +#else
>> +typedef u8 numanode_t;
>> +#endif
>> +
> 
> Do we really need numanode_t in userspace? I'd rather not, especially
> when its type is dependent on MAX_NUMNODES. Wrap with #ifdef __KERNEL__.


Will do, thanks.
