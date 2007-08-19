Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXHSDNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXHSDNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 23:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXHSDNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 23:13:32 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55963 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509AbXHSDNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 23:13:32 -0400
Message-ID: <46C7B448.3050404@vmware.com>
Date: Sat, 18 Aug 2007 20:08:56 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: skip paravirt patching when appropriate
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org> <200708181149.48217.ak@suse.de> <20070818203230.GV3672@sequoia.sous-sol.org> <alpine.LFD.0.999.0708181355280.30176@woody.linux-foundation.org> <20070818213141.GW3672@sequoia.sous-sol.org> <20070818222821.GX3672@sequoia.sous-sol.org>
In-Reply-To: <20070818222821.GX3672@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Chris Wright (chrisw@sous-sol.org) wrote:
>   
>> Now that I understand the problem, I do have a very simple (slightly
>> overkill) fix for paravirt patching.  This can be cleaned up to avoid
>> the copies when they aren't needed, but that will take a little more
>> auditing of the various patchers.  If you still prefer a revert I've
>> got one handy, and we can re-visit this all post .23.
>>     
>
> This one avoids the patching when necessary, but needs some validation on
> VMI (and Zach's not avail today).  I'll resend when I know it's working
> for all paravirt patchers.
>   

I'm back.  I'll give this one a spin after dinner tonight.

Zach
