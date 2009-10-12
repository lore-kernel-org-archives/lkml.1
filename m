Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZJLPY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZJLPY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZJLPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:24:25 -0400
Received: from host179-6-static.238-77-b.business.telecomitalia.it ([77.238.6.179]:56031
	"EHLO mail.navynet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbZJLPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:24:24 -0400
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 11:24:24 EDT
Message-ID: <4AD34614.6070701@navynet.it>
Date: Mon, 12 Oct 2009 17:07:00 +0200
From: "Massimo \"CtRiX\" Cetra" <ctrix@navynet.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rjw@sisk.pl, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	<r-4Wjt4coy.A.CwC.Wal0KB@chimera> <20091012.034224.64980795.davem@davemloft.net>
In-Reply-To: <20091012.034224.64980795.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: mcetra@navynet.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller ha scritto:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Mon, 12 Oct 2009 00:22:04 +0200 (CEST)
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
>> Subject		: Problems with net/core/skbuff.c
>> Submitter	: Massimo Cetra <mcetra@navynet.it>
>> Date		: 2009-10-08 14:51 (4 days old)
>> References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4
> 
> I don't know what to do about this one.
> 
> The user indicates that they have the vserver patches applied,
> so maybe there is some interaction with that stuff.

Actually i don't think that it's Vserver related.

I'm not a kernel hacker but the vserver patch doesn't seems to have much 
relation with networking (for who don't know vserver, it's a sort of 
advanced chroot).

I'm using OCFS2 and drbd. Both of those 2 things make heavy use of 
networking to share data between two hosts.

The backtrace seems to begin in the "world" of OFCS2.
I'm CC'ing ocfs mailing list where someome may have some clues.

Thanks,
Max





