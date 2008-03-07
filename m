Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbYCGNjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbYCGNjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYCGNiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:38:55 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:57837 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbYCGNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:38:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=XI99l4znD13EE0d7PHX9mb66++eSZiZbKExwcAgUbeEcIddQpk8sQIf1rtRyX+axRgjgGEqHqVhgP132xxFUh0302z7pohXnpJw/uP2vSLDGC6GtW5iUk3rmo8QyGruj+jrZgcWIISJa0UUFgYsjpJeAMZdMRYOKY+MiseXOvzo=
Message-ID: <47D14526.2070103@gmail.com>
Date: Fri, 07 Mar 2008 08:37:42 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: belcampo <belcampo@zonnet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
References: <47BE9781.3030304@zonnet.nl> <20080222100630.GE5906@slug>
In-Reply-To: <20080222100630.GE5906@slug>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm aware that this could be considered thread necromancy, but I
haven't yet seen any indication that that is considered a bad thing in
these here parts; if it is, then I apologize, and upon being informed of
the fact will undertake to not commit such again.)

On 2/22/2008 5:06 AM, Frederik Deweerdt wrote:

> Hello Henk,
> 
> On Fri, Feb 22, 2008 at 10:36:01AM +0100, belcampo wrote:
> 
>> Kernel 2.6.22.9 smp hyperthreading
>> BENCHMARKs: VC: 334.042s VO:   0.053s A:   0.000s Sys:   4.049s =  338.143s
>> Kernel 2.6.22.9 nonsmp/hyperthreading
>> BENCHMARKs: VC: 262.008s VO:   0.031s A:   0.000s Sys:   3.528s =  265.567s
>> with 2.6.17 kernel smp/hyperthreading pentium-pro as CPU
>> BENCHMARKs: VC: 245.175s VO:   0.050s A:   0.000s Sys:   2.479s =  247.704s
>> with 2.6.17 kernel smp/hyperthreading pentium4 optimized kernel
>> BENCHMARKs: VC: 227.992s VO:   0.051s A:   0.000s Sys:   2.551s =  230.594s
> 
> I'm not familiar with mplayer benchmarks, what do they actually 
> measure?

I don't know if this discussion got continued privately, but on the
assumption that it didn't, I think I can give at least a basic answer to
this.

The VC: value is the amount of time spent in the video-codec code during
that run, the VO: value is the amount of time spent in the video-output
code, the A: is the amount of time spent in (ISTR) audio processing -
though whether codec or audio-output or audio filters etc. is unclear, I
remember there being separate values for those rather than their being
lumped under one header- and the Sys: value is I believe the amount of
time spent in system calls.

(For the record: I'm a long-time lurker and occasional, largely
non-code, contributor on the MPlayer development lists, but I've never
had occasion to look at the code behind or the logic involved in the
-benchmark output.)

-- 
    Andrew Buehler
