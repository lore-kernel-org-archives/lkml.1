Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYKECXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYKECXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYKECXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:23:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:32926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbYKECXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:23:22 -0500
Message-ID: <4911038B.9020003@kernel.org>
Date: Wed, 05 Nov 2008 11:23:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Machek <pavel@suse.cz>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <20081104062734.GA4420@havoc.gtf.org> <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org> <20081104203036.GE5862@ucw.cz> <alpine.LFD.2.00.0811041307030.3419@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811041307030.3419@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Nov 2008 02:23:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 4 Nov 2008, Pavel Machek wrote:
>> (Is park command normally supported on modern disks? IIRC hdaps people
>> had issues with not all disks supporting it?)
> 
> The modern version of parking is called "idle immediate". It may be that 
> only laptop drives support the "unload" part. But it's definitely not an 
> ancient and deprecated thing (although calling it "parking" is apparently 
> old-fashioned :)

I'm afraid trying to use that new extension during shutdown would cause
far more trouble which would require extensive black/white list at the
end.  For hdaps, it's okay as the laptops w/ those sensors are supposed
to have matching hard drive but using it on generic machines doesn't
sound like a sane idea.

Thanks.

-- 
tejun
