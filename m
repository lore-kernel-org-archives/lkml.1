Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbZD1OtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbZD1OtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZD1Os6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:48:58 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:53394 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbZD1Os6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:48:58 -0400
Date: Tue, 28 Apr 2009 11:48:14 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc: minimizing the configuration of
	linkstation_defconfig
Message-ID: <20090428144814.GA14926@ime.usp.br>
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange> <20090424223355.GB7858@ime.usp.br> <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org> <20090428022711.GA30538@ime.usp.br> <F78629F9-59D2-4974-8461-06B7FAC2625D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F78629F9-59D2-4974-8461-06B7FAC2625D@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 28 2009, Kumar Gala wrote:
> I'm pretty sure we need this for old initrd style ramdisks so I'd prefer 
> we leave it enabled.

Oh, for oldstyle it is needed. You're right. It is better to keep it in
the defconfig. Just drop the hunk from the patch that I sent you.

>> Thanks. The MTD & PHYMAP_COMPAT are the things that have been bugging
>> me and my main reason to keep with the bleeding edge kernels is to
>> get things whey they were (regarding mtd) as in kernel 2.6.28.
>>
>> As I have no experience with MTD devices, I would appreciate a
>> reference to their workings... All that I know is that all my
>> /dev/mtd* devices are gone if I boot a 2.6.29* kernel.
>>
>> Of course, I can do a git bisect process (since the MTD subsystem
>> doesn't work as it did in the past even if I enable PHYMAP_COMPAT and
>> put the same settings there, quite unfortunately).
>
> ok.. I killed my kurobox long ago so can't be much help here.

Oh... :-(

I will post the problems that I get with MTD on my kurobox so that
people from both the linux-mtd/linuxppc-dev lists can see what is
happening and suggest some fixes.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
