Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXK0VKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXK0VKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbXK0VJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:09:55 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53132 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755044AbXK0VJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:09:54 -0500
Date: Tue, 27 Nov 2007 22:09:42 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Dave Jones <davej@redhat.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071127210942.GF3406@stusta.de>
References: <20071122343.446909000@suse.de> <adatznarrzc.fsf@cisco.com> <200711261228.15155.rusty@rustcorp.com.au> <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net> <20071127190037.GB30057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071127190037.GB30057@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 02:00:37PM -0500, Dave Jones wrote:
> On Mon, Nov 26, 2007 at 10:25:33AM -0800, Stephen Hemminger wrote:
>  
>  > 1) Why is everyone so concerned that export symbol space is large?
>  > 	- does it cost cpu or running memory?
>  > 	- does it cause bugs?
>  > 	- or are you just worried about "evil modules"?
> 
> To clarify something here, by "evil", don't necessarily think "binary only". 
> 
> Out of tree modules are frequently using symbols that they shouldn't be.
> Because they get no peer-review here, they 'get away with it' for the most part.
> Until distro vendors push rebased kernel updates that removed exports that
> should never have been exported, and suddenly people like me get bombed
> with "Fedora broke my xyz driver" mails.
>...

The real problem is that these drivers are not in the upstream kernel.

Are there common reasons why these drivers are not upstream?

> 	Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

