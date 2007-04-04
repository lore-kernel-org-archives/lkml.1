Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXDDVNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXDDVNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXDDVNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:13:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbXDDVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:13:15 -0400
Message-ID: <461414E7.6080302@online.de>
Date: Wed, 04 Apr 2007 23:13:11 +0200
From: Thomas Bittermann <t.bittermann@online.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.21-rc5] kernel/time.c: add missing symbol exports
References: <461408A6.5010005@online.de> <20070404140007.15aa1893.akpm@linux-foundation.org>
In-Reply-To: <20070404140007.15aa1893.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19RlRwXzybQRGOWVXJuATnfPjgzlzENBhQ4if5
 T/EkM3bdkCYGd/LCjnXbD6Fa+AHIFJmPwm+R7BMuoT5OLL0o5d
 dhqT9mu5+FN8/G0UqsLaw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> On Wed, 04 Apr 2007 22:20:54 +0200
> Thomas Bittermann <t.bittermann@online.de> wrote:
> 
>> This patch adds 2 missing symbol exports:
>>
>> jiffies_to_timeval
>> timeval_to_jiffies
> 
> I don't see any in-tree code which needs these symbols?
> 
> The exports might make sense from a consistency POV, but I'd be interested
> in knowing what motivated this change?
I'm working on a Fedora 7 LiveCD which integrates dm-raid4-5
(http://people.redhat.com/~heinzm/sw/dm/dm-raid45/readme). dm-raid4-5.c uses
jiffies_to_timeval() ...

Thanks for your quick response.

Thomas
