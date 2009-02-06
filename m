Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbZBFQhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbZBFQhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZBFQhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:37:24 -0500
Received: from gw.goop.org ([64.81.55.164]:38473 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZBFQhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:37:23 -0500
Message-ID: <498C6741.8000605@goop.org>
Date: Fri, 06 Feb 2009 08:37:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Campbell <ian.campbell@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org,
       Ravikiran Thirumalai <kiran@scalemp.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 5 of 7] x86/paravirt: add register-saving thunks to reduce
 caller register pressure
References: <patchbomb.1233182100@abulafia.goop.org>	<7d4a052c499dbfe5e816.1233182105@abulafia.goop.org> <87fxisvxb9.fsf@basil.nowhere.org>
In-Reply-To: <87fxisvxb9.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I had something like this (but not as generic) for the old pre
> unification semaphores on x86-64 too. I think it's a generally useful
> facility for lots of things (in fact I've been asking gcc developers
> for providing this in a general way for some time).
>   

What other users do you have in mind?

> So I would suggest to move the necessary macros to do that outside
> paravirt.h into a separate include so that it can be used independently
> and not call it PV_*.

That wouldn't be too hard to do, but I don't think its something we 
should do lightly.  There are quite a few pitfalls, and the bugs can get 
pretty obscure.  It would also mean bringing out a lot of the PV_CALL 
machinery, and I'm not sure we really want to give that too much 
exposure in the light of day.

    J

