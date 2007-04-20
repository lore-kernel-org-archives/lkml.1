Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXDTKLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXDTKLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbXDTKLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:11:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:5009 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbXDTKLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=G55YT0iVreoibtSacLbAXMyBRMO94QmpydEoIqjp5vrCDStSY4YFNdcpkY0epgEL2YjH7B0PRdba6OjGzxKuKi4n+nGdJ/rkuvZO1CydGPFB/TdUz7iRgw9oU/y7tGzkg9ce9nnZvIrlen4RXr6Z+MRDgovItWMbyTZwe4fPCtk=
Message-ID: <462891A8.6080502@gmail.com>
Date: Fri, 20 Apr 2007 13:10:48 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Fabio Comolli <fabio.comolli@gmail.com>
CC: Brad Campbell <brad@wasp.net.au>, Alex Dubov <oakad@yahoo.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <204224.14405.qm@web36703.mail.mud.yahoo.com>	 <462877E8.2070005@wasp.net.au> <b637ec0b0704200131g6297d5d5q842edbf160940170@mail.gmail.com>
In-Reply-To: <b637ec0b0704200131g6297d5d5q842edbf160940170@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> > Have you looked at the last version (0.8)? It fixed all outstanding 
>> issues (as far as I know).
>> >
>>
>> Seconded. I've been running Alex's latest driver since its release. I 
>> routinely suspend/resume
>> 60-100 times between boots to S3 and disk, I've suspended with cards 
>> in the socket and I've tested
>> it using SD and MMC .. I've not been able to fault it now. In fact, 
>> checking my mail archives, my
>> last reported bug was on the 17th of Feb and it has been rock solid 
>> since. I just don't think about
>> it anymore, it simply works...
>>

Well, I am tracking Alex's svn. It is for off-the-tree builds. I 
reorganized Alex's code in Oct 2006 and added
a patch to my debian/patches. Until debian shipped linux-2.6.20, there 
were no [tifm_*] in their tree, so no conflicts. The 2.6.20 came with 
tifm_sd-v0.6 which is not so stable. I dug lkml and bugzilla.kernel.org 
for fresh patches, but found 
http://bugzilla.kernel.org/show_bug.cgi?id=8052. Which made me think, 
svn is still unstable. I merged in-kernel updates to my old (v2.6.18-*) 
version. It compiles and runs OK, so I posted it. No offense to anyone.

Best regards,
Sergey
