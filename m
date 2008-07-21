Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYGULm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYGULm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbYGULl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:41:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:36119 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbYGULl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kX6gXPFf+9ygpOuLR27tUVFxV61HqkN1lfUalVtOykIBnUGGnoTjYhIu8vGY3tunVl
         2TxC2EjABYnIujZ6pZj+wSW+n+A9hL1MV2HxJYQpEGKnKZZd7MNY13tvB0x+yGidBdIN
         cSvmaWbZ0QOFGD9wpLah2lmxjChT0Nph1DXWQ=
Message-ID: <19f34abd0807210441o75c07e0fs60b49157318f59bb@mail.gmail.com>
Date: Mon, 21 Jul 2008 13:41:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080717235657.GB6833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <19f34abd0807171627t1dd0ac5bx26535b5e19606835@mail.gmail.com>
	 <20080717235657.GB6833@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 1:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>> On Thu, Jul 17, 2008 at 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> > With this config:
>> >
>> >   http://redhat.com/~mingo/misc/config-Thu_Jul_17_20_24_45_CEST_2008.bad
>> >
>>
>> It doesn't actually work. The config says
>>
>>     # head: 088fcf34
>>
>> and I checked out this from the tip tree. But kernel-config still
>> complains about unknown config options... What went wrong?
>
> that's ok - i've got some local qa helpers that have config options.
>
> Things like making SMP bootups more likely in randconfig, adding various
> boot parameters to the bootup via .config methods (so that boot
> parameters can be randomized via make randconfig), etc.

Hm, your config doesn't contain SLUB_DEBUG either. Isn't that a
requirement for seeing the BUG you're getting?

$ grep SLUB config-Thu_Jul_17_20_24_45_CEST_2008.bad
# CONFIG_SLUB_DEBUG is not set
CONFIG_SLUB=y

Did you post the wrong config?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
