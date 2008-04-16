Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbYDPQVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbYDPQVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYDPQVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:21:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbYDPQVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:21:33 -0400
Message-ID: <48062723.2020507@redhat.com>
Date: Wed, 16 Apr 2008 12:19:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tom Zanussi <zanussi@comcast.net>
CC: David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, tzanussi@gmail.com
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer
References: <4804C95F.2080204@redhat.com> <1208319769.7893.16.camel@charm-linux>
In-Reply-To: <1208319769.7893.16.camel@charm-linux>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

Tom Zanussi wrote:
> On Tue, 2008-04-15 at 11:27 -0400, Masami Hiramatsu wrote:
>> Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
>> when the array size is bigger than one page. This enables relayfs to support
>> bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> ---
>> This is useful for a 64-bit system which has a plenty of memory (tens of
>> giga bytes) and a large kernel memory space.
>>
>> I tested it on x86-64 and ia64.
>>
> 
> Hi,
> 
> It looks ok to me, but it might be a little cleaner and avoid some
> duplication if you add the new code as a couple of functions instead.
> Just a suggestion...

Sure, that is a good idea, I'll renew my patch.
Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

