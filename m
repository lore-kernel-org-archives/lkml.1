Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbZBVS20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbZBVS20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 13:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZBVS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 13:28:17 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:44004 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZBVS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 13:28:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gl9MSM1H29iGv4wTybidBja0K6DVsokL/GBoM5OQZCs3hizKwj6uBrTPWyEC//+Z4p
         KP59gVy0GB2k4OR5LGFcbqJUIapD8Nlmm8rizY/pjE0T8vWAZojTpsIEDMbVFkqu55E/
         6y4PML7JrwqBHstgRK3gSopzx1QsTjNkeQTdc=
MIME-Version: 1.0
In-Reply-To: <20090222142351.GG1586@ucw.cz>
References: <20090213155507.GA2838@Krystal> <20090213173352.GB4684@Krystal>
	 <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
	 <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain>
	 <20090213185411.GB7124@Krystal>
	 <20090213193619.GH6854@linux.vnet.ibm.com>
	 <8bd0f97a0902132107r3651ce4rc5bc4e027268e2aa@mail.gmail.com>
	 <20090214052030.GB7194@linux.vnet.ibm.com>
	 <8bd0f97a0902132146t2badab79ue76e0a43d74c95ca@mail.gmail.com>
	 <20090222142351.GG1586@ucw.cz>
Date: Sun, 22 Feb 2009 13:28:15 -0500
Message-ID: <8bd0f97a0902221028l4917726fr79ab587260458814@mail.gmail.com>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux (repost)
From: Mike Frysinger <vapier.adi@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: paulmck@linux.vnet.ibm.com, Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 09:23, Pavel Machek wrote:
>> > If Blackfin handles hotplug CPU, that may
>> > need attention as well, since tasks affinitied to the CPU being removed
>> > can end up with their affinity set to all CPUs.  And there are probably
>> > other issues.
>>
>> no, we dont support hotplugging of CPUs.  there is no hardware support
>> for it, so i think the only thing you'd gain is perhaps power savings
>> ?  not sure it would even work in our case though as the hardware does
>> not support restarting or shutdown of one core ... they both have to
>> restart/shutdown.  putting one core into a constant idle loop would
>> save power, but that can already be accomplished by reducing the apps
>> that go onto a specific core.
>
> Well, cpu hotplug is needed for suspend and hibernation...

we dont currently support hibernation (or at least we've never tested
it), but suspend to ram works fine on UP systems.  i'll open a tracker
item for someone to check suspend to ram on SMP systems.
-mike
