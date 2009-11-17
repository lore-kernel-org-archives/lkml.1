Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZKQSBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZKQSBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZKQSBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:01:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbZKQSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:01:39 -0500
Message-ID: <4B02E354.9060102@zytor.com>
Date: Tue, 17 Nov 2009 09:54:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, rdreier@cisco.com, rdunlap@xenotime.net,
       tj@kernel.org, andi@firstfloor.org, gregkh@suse.de,
       yhlu.kernel@gmail.com, rientjes@google.com, rostedt@goodmis.org,
       rusty@rustcorp.com.au, seto.hidetoshi@jp.fujitsu.com, steiner@sgi.com,
       fweisbec@gmail.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration	bootup
 messages
References: <20091116215052.GK5653@lenovo> <20091116.190922.182816918.davem@davemloft.net> <20091117155946.GA5476@lenovo> <20091117.082928.10537098.davem@davemloft.net> <20091117174204.GD5476@lenovo> <4B02E242.8040800@sgi.com>
In-Reply-To: <4B02E242.8040800@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 09:49 AM, Mike Travis wrote:
> 
> I'd like to say that, but Peter wanted it to become an inlined function
> return value, and there are too many references in too many arches to
> a scalar value, so that moves it out of the scope of this patch set.
> 

Another thing: if we do a lot of testing for "are we running on the boot
CPU", an is_boot_cpu() or is_boot_cpu(cpu) function might be a nice
piece of syntactic sugar (and more immediately implementable.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

