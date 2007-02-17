Return-Path: <linux-kernel-owner+w=401wt.eu-S2992923AbXBQSIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992923AbXBQSIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992985AbXBQSIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:08:23 -0500
Received: from mail.tmr.com ([64.65.253.246]:45982 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992923AbXBQSIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:08:22 -0500
Message-ID: <45D7450F.6090309@tmr.com>
Date: Sat, 17 Feb 2007 13:10:23 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>
CC: Juan Piernas Canovas <piernas@ditec.um.es>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org>
In-Reply-To: <20070217151108.GA301@lazybastard.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Fri, 16 February 2007 18:47:48 -0500, Bill Davidsen wrote:
>   
>> Actually I am interested in the common case, where the machine is not 
>> out of space, or memory, or CPU, but when it is appropriately sized to 
>> the workload. Not that I lack interest in corner cases, but the "running 
>> flat out" case doesn't reflect case where there's enough hardware, now 
>> the o/s needs to use it well.
>>     
>
> There is one detail about this specific corner case you may be missing.
> Most log-structured filesystems don't just drop in performance - they
> can run into a deadlock and the only recovery from this is the lovely
> backup-mkfs-restore procedure.
>   
I missed that. Which corner case did you find triggers this in DualFS?
> If it was just performance, I would agree with you.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


