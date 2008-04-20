Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbYDTMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbYDTMSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYDTMS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:18:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbYDTMS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:18:28 -0400
Message-ID: <480B321B.5020802@zytor.com>
Date: Sun, 20 Apr 2008 08:07:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andres Salomon <dilinger@queued.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com, Mitch Bradley <wmb@firmworks.com>
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	 <20080419031024.GC3503@nineveh.local>	 <20080418202925.b18452c5.akpm@linux-foundation.org>	 <20080419092544.378664a8@ephemeral>	 <20080419133909.5aa6b63e@ephemeral> <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
In-Reply-To: <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Sat, Apr 19, 2008 at 10:39 AM, Andres Salomon <dilinger@queued.net> wrote:
>>  This adds 32-bit support for calling into OFW from the kernel.  It's useful
>>  for querying the firmware for misc hardware information, fetching the device
>>  tree, etc.
>>
>>  There's potentially no reason why other platforms couldn't use this, but
>>  currently OLPC is the main user of it.
>>
>>  This work was originally done by Mitch Bradley.
>>

Hm.  This interface seems more than a bit ad hoc.  In particular, I 
*really* don't like the swapper_pg_dir hack.

"There must be a better way."

	-hpa
