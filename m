Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbYDKKfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbYDKKfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbYDKKeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:34:50 -0400
Received: from styx.suse.cz ([82.119.242.94]:56752 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759019AbYDKKet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:34:49 -0400
Date: Fri, 11 Apr 2008 12:34:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
In-Reply-To: <20080411102548.GO10801@elte.hu>
Message-ID: <Pine.LNX.4.64.0804111229020.3896@jikos.suse.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
 <Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz> <20080411102548.GO10801@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Ingo Molnar wrote:

> > [ CCs added ]
> thanks Jiri, i've applied both patches of yours. (let me know if there 
> are any updated patches) do they solve the problem?

Hi Ingo,

thanks, but I don't think they are the proper fix anymore. We'd rather 
figure out why interrupts were enabled in the first place while the code 
was running.

Which is quite difficult, because Zdenek doesn't seem to be able to 
reproduce it, so we even don't know whether it has been caused by KVM or 
not.

-- 
Jiri Kosina
SUSE Labs
