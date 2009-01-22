Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZAVTlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZAVTlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZAVTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:41:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:55163 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975AbZAVTlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:41:08 -0500
Message-ID: <4978CBD1.4000901@sgi.com>
Date: Thu, 22 Jan 2009 11:41:05 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Robert Richter <robert.richter@amd.com>, Tony Luck <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] cpumask: modifiy oprofile initialization
References: <20090122131153.GP21604@erda.amd.com> <1232630055-32451-1-git-send-email-robert.richter@amd.com> <20090122133729.GB26529@elte.hu>
In-Reply-To: <20090122133729.GB26529@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
> 
>> Delta patch to f7df8ed164996cd2c6aca9674388be6ef78d8b37 for
>> tip/cpus4096.
>>
>> Moved initialization to sync_start()/sync_stop(). No changes needed in
>> buffer_sync.h and oprof.c anymore.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Mike Travis <travis@sgi.com>
>> Signed-off-by: Robert Richter <robert.richter@amd.com>
>> ---
>>  drivers/oprofile/buffer_sync.c |   20 ++++++--------------
>>  drivers/oprofile/buffer_sync.h |    4 ----
>>  drivers/oprofile/oprof.c       |    9 +--------
>>  3 files changed, 7 insertions(+), 26 deletions(-)
> 
> applied to tip/cpus4096, thanks Robert!
> 
> 	Ingo

Built and tested on an Altix 4700.

Cheers,
Mike

