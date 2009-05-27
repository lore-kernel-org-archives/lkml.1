Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZE0VTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZE0VTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZE0VTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:19:40 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29176 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZE0VTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:19:39 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Owens, James" <JOwens@hp.com>
CC: Martin Knoblauch <knobi@knobisoft.de>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
       Kay Sievers <kay.sievers@vrfy.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Wed, 27 May 2009 21:18:58 +0000
Subject: RE: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Thread-Topic: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Thread-Index: AcnfB4jJW0o0DGOASJK4uSgYWTCk0gACQ+Ww
Message-ID: <0F5B06BAB751E047AB5C87D1F77A7788694630BB17@GVW0547EXC.americas.hpqcorp.net>
References: <1240977096.5478.3.camel@marge.simson.net>
 <20090429011755.c141c599.akpm@linux-foundation.org>
 <20090429120827.GI8633@ZenIV.linux.org.uk>
 <1241014725.15095.19.camel@marge.simson.net>
 <20090505154911.e0309a4f.akpm@linux-foundation.org>
 <1241585140.5196.28.camel@marge.simson.net>
 <957194.27869.qm@web32605.mail.mud.yahoo.com>
 <1241599065.18090.18.camel@marge.simson.net>
 <461911.6351.qm@web32603.mail.mud.yahoo.com>
 <20090526233102.b86e7f84.akpm@linux-foundation.org>
 <20090527112153.GE5816@parisc-linux.org>
 <840102.98312.qm@web32603.mail.mud.yahoo.com> <4A1D8161.2020009@hp.com>
 <0F5B06BAB751E047AB5C87D1F77A7788694630B931@GVW0547EXC.americas.hpqcorp.net>
 <4A1D9EC2.4090602@hp.com>
In-Reply-To: <4A1D9EC2.4090602@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Owens, James 
> Sent: Wednesday, May 27, 2009 3:13 PM
> To: Miller, Mike (OS Dev)
> Cc: Martin Knoblauch; Matthew Wilcox; Andrew Morton; Mike 
> Galbraith; viro@ZenIV.linux.org.uk; rjw@sisk.pl; 
> linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk; 
> Kay Sievers; shemminger@vyatta.com; Jesse Barnes
> Subject: Re: Analyzed/Solved/Bisected: Booting 
> 2.6.30-rc2-git7 very slow
> 
> Miller, Mike (OS Dev) wrote:
> >>>  Finally, today I built the ccsii driver into the kernel. 
> >> It was previously modularized and loaded from initrd. The second 
> >> "sysfs" line went away. But does this make cciss guilty? It is now 
> >> loaded about 2 seconds earlier in the boot sequence, which 
> is a big 
> >> change in timing I guess.
> >>>  Enlighten me :-)
> >> No idea what is going on, but since I saw your May 20 
> message, I have 
> >> been trying to wake up someone whose day job it should be to care 
> >> about dl380s and smartarrays. :)
> > 
> > What? I know Martin has pinged me in the past, but I do not 
> think it was about this issue. If there's multiple sysfs 
> entries for cciss I can't explain that offhand. We do little 
> to nothing for sysfs in the driver.
> > Had something similiar happen recently where "/" changed to 
> "!". Had do to with our nested directory structure, 
> /dev/cciss/name vs /dev/name. But we did not make that change, either.
> 
> It was not you that I was trying to get to look at this...
> but now that I have your attention :)
> 
> I did not think it pointed at cciss or the sysfs entry as 
> being the problem.  I was wondering more about platform probe 
> timing, the bios, and how each card firmware reacts given 
> what I thought the patch did.  I could be totally wrong about 
> that as I work at the filesystem level.
> 
> We have not seen the problem yet but we have different 
> proliants/smartarrays.
> 
> If you can try it on matching hardware, great, if not then 
> someone will eventually find a system to test it.
> 
Sorry, I don't have any hw that old. We're very limited on space these days.

-- mikem