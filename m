Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbYAOPwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbYAOPwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYAOPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:51:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbYAOPv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:51:56 -0500
Message-ID: <478CD698.1090402@sgi.com>
Date: Tue, 15 Jan 2008 07:51:52 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] x86: Change size of node ids from u8 to u16 V2
References: <20080115021735.779102000@sgi.com> <20080115021736.236433000@sgi.com> <478C4BBD.9050707@cosmosbay.com>
In-Reply-To: <478C4BBD.9050707@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
>
>> --- a/include/asm-x86/mmzone_64.h
>> +++ b/include/asm-x86/mmzone_64.h
>> @@ -15,8 +15,8 @@
>>  struct memnode {
>>      int shift;
>>      unsigned int mapsize;
>> -    u8 *map;
>> -    u8 embedded_map[64-16];
>> +    u16 *map;
>> +    u16 embedded_map[64-16];
> 
> Must change to 32-8 here, or 64-8 and change the comment (total size =
> 128 bytes). If you change to 32-8, check how .map is set to embedded_map.
> 
>>  } ____cacheline_aligned; /* total size = 64 bytes */
>>  extern struct memnode memnode;
>>  #define memnode_shift memnode.shift

Thanks! 
