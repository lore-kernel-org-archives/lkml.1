Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZGGIuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZGGIuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZGGIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:49:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbZGGIt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:49:58 -0400
Date: Tue, 7 Jul 2009 10:50:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Andi Kleen <andi@firstfloor.org>
Cc: rjw@sisk.pl, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <87eiss7uhb.fsf@basil.nowhere.org>
Message-ID: <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[added Dmitry to CC]

On Tue, 7 Jul 2009, Andi Kleen wrote:

> One new issue I see in 2.6.30 (I think I saw it in some rc*s) too is 
> that console switch often leaks the Fkey of the console switch into the 
> target console.
> 
> The symptome is that e.g. firefox if it was active and you're switching
> into X displays its help screen (F1 = help). It happens on non X 
> consoles too, but of course the symptoms are different here.
> 
> That's a regression against 2.6.29; I don't remember it in .29
> 
> Haven't investigated code.

Are you seeing with a specific keyboard type(s), or is this a general 
problem? Could you confirm whether it is specific either 
to PS2 or USB keyboards only, or it does happen for both?

Thanks,

-- 
Jiri Kosina
SUSE Labs
