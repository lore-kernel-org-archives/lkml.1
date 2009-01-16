Return-Path: <linux-kernel-owner+w=401wt.eu-S936259AbZAPP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936259AbZAPP2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761969AbZAPP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:28:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbZAPP2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:28:20 -0500
Message-ID: <4970A78B.8050605@redhat.com>
Date: Fri, 16 Jan 2009 09:28:11 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Pavel Machek <pavel@suse.cz>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
References: <496EB639.6090800@redhat.com>            <20090116084828.GB4795@atrey.karlin.mff.cuni.cz> <16406.1232119029@turing-police.cc.vt.edu>
In-Reply-To: <16406.1232119029@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 16 Jan 2009 09:48:28 +0100, Pavel Machek said:
> 
>> Emergency Sync should not do this. Invent another key.
>>
>> ...because otherwise, if you hit emergency sync but the system is
>> still alive and relies on filesystem freezing, bad stuff will happen.
> 
> Under what conditions would a system be alive and relying on freezing,
> *and* an emergency thaw would be worse than whatever reason you're doing
> an emergency sync?
> 
> Hmm.. guess you *could* get into trouble if you tried to do a Sysrq-[not-s]
> and hit the wrong key - but you have the same danger if you have *any*
> sysrq- invoking an emergency_thaw and hit it by accident...

I could certainly use up another key ('z' is available for unfreeZe) but
I have the same question; under what conditions do you expect to need an
emergency sync and also need to maintain frozen filesystems as frozen?

>From a maximum flexibility and control perspective, it'd be better to
have them separated I suppose.  Is it worth using up another available key?

-Eric

