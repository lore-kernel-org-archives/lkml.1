Return-Path: <linux-kernel-owner+w=401wt.eu-S934563AbXHLL2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563AbXHLL2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbXHLL2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:28:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41605 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbXHLL2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:28:39 -0400
Date: Sun, 12 Aug 2007 13:28:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it,
 anyways? [compare with e.g. NBD + MD raid])
In-Reply-To: <200708121335.17267.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0708121325170.28963@fbirervta.pbzchgretzou.qr>
References: <200708121335.17267.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 13:35, Al Boldi wrote:
>Lars Ellenberg wrote:
>> meanwhile, please, anyone interessted,
>> the drbd paper for LinuxConf Eu 2007 is finalized.
>> http://www.drbd.org/fileadmin/drbd/publications/
>> drbd8.linux-conf.eu.2007.pdf
>>
>> but it does give a good overview about what DRBD actually is,
>> what exact problems it tries to solve,
>> and what developments to expect in the near future.
>>
>> so you can make up your mind about
>>  "Do we need it?", and
>>  "Why DRBD? Why not NBD + MD-RAID?"

I may have made a mistake when asking for how it compares to NBD+MD.
Let me retry: what's the functional difference between
GFS2 on a DRBD .vs. GFS2 on a DAS SAN?

>Now, shared remote block access should theoretically be handled, as does 
>DRBD, by a block layer driver, but realistically it may be more appropriate 
>to let it be handled by the combining end user, like OCFS or GFS.


	Jan
-- 
