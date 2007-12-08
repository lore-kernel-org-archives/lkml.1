Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXLHRlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXLHRlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbXLHRlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:41:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXLHRlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:41:05 -0500
Message-ID: <475AD585.7020908@redhat.com>
Date: Sat, 08 Dec 2007 11:33:57 -0600
From: Mike McGrath <mmcgrath@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jon Masters <jonathan@jonmasters.org>,
       Mike McGrath <mmcgrath@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org>
In-Reply-To: <20071208173204.GI17037@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 02:37:57AM -0500, Jon Masters wrote:
>   
>>> BTW, You may be better off using "uuidgen -t" to generate the UUID in
>>> the smolt RPM, since that will use 12 bits of randomness from
>>> /dev/random, plus the MAC, address and timestamp.  So even if there is
>>> zero randomness in /dev/random, and the time is January 1, 1970, at
>>> least the MAC will contribute some uniqueness to the UUID.
>>>       
>> I haven't checked how uuidgen uses the MAC, but I would suggest that
>> that is not something Fedora should jump at doing - although it would
>> help ensure unique UUIDs, it also contributes to the tinfoil hat
>> responses that usually come up with things like smolt.
>>     
>
> Huh?  What's the concern?  All you are submitting is a list of
> hardware devices in your system.  That's hardly anything sensitive....
>   

We actually had a very vocal minority about all of that which ended up 
putting us in the unfortunate position of generating a random UUID 
instead of using a hardware UUID from hal :-/

    -Mike
