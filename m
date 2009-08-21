Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZHUNEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZHUNEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZHUNEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:04:42 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755574AbZHUNEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:04:41 -0400
Message-ID: <4A8E9B63.4090400@sgi.com>
Date: Fri, 21 Aug 2009 15:04:35 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest Linus tree oopses on Nehalem box
References: <4A8E7CBE.3020209@sgi.com> <20090821114645.GD24647@elte.hu>
In-Reply-To: <20090821114645.GD24647@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 01:46 PM, Ingo Molnar wrote:
> Might be useful to see your full crashlog, if you are allowed to
> post that, plus your kernel .config would be useful to know too.
> Plus would be useful to know whether this is a regression relative
> to .30 or a yet unfixed bug triggering on your class of hardware.

Hi again,

It looks like this is either timing related or a false alarm :(

I saved the .config reverted to an older commit, and then tried to go
back, and now the thing will suddenly boot.

I'll try to see if I can reproduce it, if I manage, I shall be happy to
post the .config and the full boot log. It's a Supermicro motherboard of
some sort:

Supermicro X8DTN+
AMIBIOS Core Ver:08.00.15

There is nothing special about it, but I know the BIOS is utter junk.

Sorry for the noise.

Cheers,
Jes
