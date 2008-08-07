Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbYHGQZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbYHGQZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYHGQZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:25:34 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:52531 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYHGQZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:25:34 -0400
Message-ID: <2611.69.2.248.210.1218125052.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <489B199B.40305@s5r6.in-berlin.de>
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>
    <489B199B.40305@s5r6.in-berlin.de>
Date: Thu, 7 Aug 2008 10:04:12 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> If there are interdependencies in these datasets, with which mechanisms
> if not locks do you serialize critical sections?
>
>
>> +void MDBInitializeDebugger(void)
>> +{
> ...
>> +   for (i=0; i < MAX_PROCESSORS; i++)
>> +   {
>> +      BreakMask[i] = 0;
>> +      ProcessorHold[i] = 0;
>> +      ProcessorState[i] = 0;
>> +      ProcessorMode[i] = 0;
>> +   }
>
> Not necessary, because static (and extern) variables are already
> implicitly initialized to zero.
> --
> Stefan Richter
> -=====-==--- =--- --===
> http://arcgraph.de/sr/


Another M$ legacy relict. On Microsoft C compilers (older ones) failure to
initialize global data produces undefined results since they do not always
zero out memory and global data -- they still do not in all cases.

I will remove this a well.  Still more checkpatch.pl stuff for me to do.  
am down to about 3000+ noisy messages now ...


Jeff

>


