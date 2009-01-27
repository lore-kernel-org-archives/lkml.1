Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZA0CCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZA0CCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 21:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZA0CC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 21:02:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:36175 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZA0CC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 21:02:28 -0500
Message-ID: <497E6B34.1020508@kernel.org>
Date: Tue, 27 Jan 2009 11:02:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: Fix __per_cpu_load relocation
References: <20090126103243.GA31307@elte.hu> <1232977445-11815-1-git-send-email-brgerst@gmail.com> <20090126141832.GA31442@elte.hu>
In-Reply-To: <20090126141832.GA31442@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 27 Jan 2009 02:02:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Brian Gerst <brgerst@gmail.com> wrote:
> 
>> This patch fixes this error:
>> WARNING: Absolute relocations present
>> Offset     Info     Type     Sym.Value Sym.Name
>> c0a4e07d 00e78001   R_386_32 c0ab0000  __per_cpu_load
>>
>> Now, __per_cpu_load is a section-relative symbol:
>> c0aa4000 D __per_cpu_load
>> c0aa4000 A __per_cpu_load_abs
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> 
> Applied to tip/core/percpu, thanks Brian!

Heh.. Thanks.  Sorry about lack of response.  It's lunar new year's
day here and I'm off till tomorrow.  I'll start reviewing and
integrating posted patches from tomorrow.

-- 
tejun
