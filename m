Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXEBFyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXEBFyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030818AbXEBFyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:54:49 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:31341 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030624AbXEBFyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:54:47 -0400
Message-ID: <46382798.2090709@interia.pl>
Date: Wed, 02 May 2007 07:54:32 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Tim Hockin <thockin@hockin.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Natsemi DP83815 driver spaming
References: <46365887.3010705@interia.pl>	 <20070430205522.abad2481.akpm@linux-foundation.org>	 <20070501084639.GA528@sirena.org.uk> <46371590.4090004@interia.pl>	 <20070501180830.GA31630@sirena.org.uk> <46379A7E.3000109@interia.pl>	 <20070501212750.GC31630@sirena.org.uk> <b3ece790705011543gdca3a9ei905d3499b6c18dc8@mail.gmail.com>
In-Reply-To: <b3ece790705011543gdca3a9ei905d3499b6c18dc8@mail.gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: df796acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > >  * 2) check for sudden death of the NIC:
>> > >  *    It seems that a reference set for this chip went out with
>> incorrect info,
>> > >  *    and there exist boards that aren't quite right.  An
>> unexpected voltage
>> > >  *    drop can cause the PHY to get itself in a weird state
>> (basically reset).
>> > >  *    NOTE: this only seems to affect revC chips.
>>
>> > Code commented out and NIC is working OK. Strange.
>> > eth0: DSPCFG accepted after 0 usec.
>> > eth0: link up.
>> > eth0: Setting full-duplex based on negotiated link capability.
>> > dspcfg = 0x00000000  np->dspcfg = 0x00005060
>>
>> Oh, that's entertaining.  I have to confess that I've never seen an that
>> triggered the workaround before - adding the maintainer, Tim Hockin, who
>> may be able to shed some light on the expected behaviour here?
> 
> It's been quite a while since I dealt with this issue, so I am going
> on faulty memory.  A particular reference design for this chip had bad
> resistor values, or something similar.  That caused the chip to get
> very very confused and need a reset.
Can You send me documentation? I can't find anything in datasheet. 
I will replace bad resitors with correct ones.
> So the driver is finding your chip to be hosed over and over again.
> dspcfg = 0x000000 is bad.  I'd be very surprised if you don't get
> other wierdness - bad performance or noise or who knows what.
No. It is much better. Much less packets need to be retransmitted.  
I was blaming w3cache.tkdami.net earlier.
> You could take out the error message and just let the driver do it's
> thing, or you can try to run with that logic removed.  But I'd measure
> both and see what they do.  Specifically - look  for packet errors.
With code commented out I have 1 error / 30000 transmitted packets from 
DP83815C. I have 1 error / 100000 transmitted packets to DP83815C. Maybe 
it works at all because I have short cable, only 10m long.
I don't remember any errors with plain 2.6.21.1.
> Tim
Rafa³


----------------------------------------------------------------------
NIE KUPUJ!!!
...zanim nie porownasz cen >> http://link.interia.pl/f1a5e



