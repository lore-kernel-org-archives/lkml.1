Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbXJYNLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbXJYNLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 09:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbXJYNK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 09:10:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:19852 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbXJYNK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 09:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qQM1poXypCFbNV0wV4tgxQ7xkS8MN8dBNVeex7BiYy0jhUey3rpo93IN0KjQG0sRhLFMTHb/WCESvXOFrqGndT5S+1OdiieT/1hTh/BHdWMNW1s0B8yKY9NT1gZqfPVZD87i/7tV0mINdHPdKZxhfH653srOAhY0ZmxJtbFBkDI=
Message-ID: <4720959E.3030805@googlemail.com>
Date: Thu, 25 Oct 2007 15:09:50 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org
Subject: Re: Resume problems
References: <471CCC98.10101@googlemail.com> <471D3C26.3090602@googlemail.com> <471D47D2.2070707@googlemail.com> <200710240057.10131.rjw@sisk.pl>
In-Reply-To: <200710240057.10131.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>
>> After all I think all this problems may be some who ACPI related 
>> but the question is why they get triggered by Suspend/Hibernation.
> 
> They certainly are ACPI-related, because the only difference between level 4
> and level 3 suspend testing is that some global ACPI methods are executed
> at level 3 (in addition to level 4).
> 
> Unfortunately, I have no idea what to do next, for now.
> 
> I think you can file a bug report at http://bugzilla.kernel.org and put a link
> to this thread in there (against ACPI and please add my address to the CC
> list).

Also I patched 2.6.23 with that patch and Hibernation works out of box , Suspend to Ram seems to work
fine , just my video card is acting up ( old nvidia card ) I'll play with vbe tool on weekend.

Also I can reproduce that bug in 2.6.23 when I use standby.

I've started to bisect but it will take some time. When I'm done I will post an bug report.

Thanks for your help so far.

> 
> Greetings,
> Rafael
> 

Gabriel
