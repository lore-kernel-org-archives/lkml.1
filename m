Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbXHRN7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbXHRN7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 09:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXHRN7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 09:59:11 -0400
Received: from web38905.mail.mud.yahoo.com ([209.191.125.111]:29469 "HELO
	web38905.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751608AbXHRN7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 09:59:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hPt9dDraCGVGHo8243GqgLsj1rUPLUmjmXKIZnuhR6BgBJp6qNixaGyctC3o8pbOYytH6GgLBORz/ROSdDOnLM7/CjQCfpHwatAzJYw0YWlw2Jc/pGFwOxG/5vVixAixiav7mSopVnU116xA2A0b5Kz61hye64NB+sNxlJ+/drE=;
X-YMail-OSG: ob5dH6gVM1lDiuM28ZLAzrMW13ylKv.m4.HjSbpHrS.2DC5s2LZ3jVns5u4z7AiPpmyy3KVq8r6cMPRv6CRIvuoV81lSQ92kBDWU6FkgVw_UEnOeBnvwdTf9Wh5P.Q--
Date: Sat, 18 Aug 2007 06:59:08 -0700 (PDT)
From: Kevin E <kevin360@yahoo.com>
Subject: Re: Marvell 88E8056 gigabit ethernet controller
To: Willy Tarreau <w@1wt.eu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070818121714.GA28247@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <283388.84897.qm@web38905.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Willy Tarreau <w@1wt.eu> wrote:

> OK, in this trace, both controllers are on the same
> bus. The broken
> one has 'Capabilities: [100] Advanced Error
> Reporting' the other
> does not have, and the bridge to this bus has two
> more capabilities :
> 'Capabilities: [100] Virtual Channel' and
> 'Capabilities: [180] Unknown (5)'.
> 
> I don't know whether it can jutify a different
> behaviour. Also, maybe this
> is caused by a minuscule difference in the BIOS
> setup ?

I just checked the BIOS' between the two machines and
there was one slight difference.  Working machine I
had serial port turned off and the parallel port setup
differently, so I made changes to the broken machines
BIOS so they are identical.  After making the change I
checked 'lspci -vvv' on the broken one and it's the
same output as before.  

I tested the Marvell interface to see if it made any
difference and the line died after about a second of
transfering data.  dmesg reported this:

sky2 eth1: enabling interface
sky2 eth1: ram buffer 0K
sky2 eth1: Link is up at 100 Mbps, full duplex, flow
control both
sky2 0000:04:00.0: error interrupt status=0x80000000
sky2 eth1: hw error interrupt status 0x8
sky2 eth1: MAC parity error
sky2 0000:04:00.0: error interrupt status=0x80000000
sky2 eth1: hw error interrupt status 0x8
sky2 eth1: MAC parity error
sky2 eth1: disabling interface


Kevin


       
____________________________________________________________________________________Ready for the edge of your seat? 
Check out tonight's top picks on Yahoo! TV. 
http://tv.yahoo.com/
