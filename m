Return-Path: <linux-kernel-owner+w=401wt.eu-S1764810AbZE1Usc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764810AbZE1Usc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764250AbZE1UsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:48:17 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:39576 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764150AbZE1UsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:48:16 -0400
Message-ID: <293616.85890.qm@web32604.mail.mud.yahoo.com>
X-YMail-OSG: 9Xy.86EVM1nYx4AJOqTufFnpMWPa19EZ9L5fPlRkrvdzTyTtao29RRKGrPnPnGfOHsvnlcI2.zNW2vfEY_xoFEMBiF.0K4ufAeddz.EiQosBzXdFuesKFFzUvm3uhG_prDJE1K6RrvqNq_F6vPC8D_NFXhOE2gPUy3m_sD9EXtoowMuKHyj8qP0RVAUwEyOUp37m9sH8JYp.EeHi56goCSJJ7KZHyBbvYyIVN.L1NN0VbFBwnSVxlwXCHsrhdHAM.DnLhwopXYolDctklsxQYKGevOlGVg0zvpvtDUIE9WYYkgiWib6_bgMSk3E7kKgA7jcCQ_8zHtmmzmPQbTFgSF0-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <1241014725.15095.19.camel@marge.simson.net> <20090505154911.e0309a4f.akpm@linux-foundation.org> <1241585140.5196.28.camel@marge.simson.net> <957194.27869.qm@web32605.mail.mud.yahoo.com> <1241599065.18090.18.camel@marge.simson.net> <461911.6351.qm@web32603.mail.mud.yahoo.com> <20090526233102.b86e7f84.akpm@linux-foundation.org> <20090527112153.GE5816@parisc-linux.org> <840102.98312.qm@web32603.mail.mud.yahoo.com> <4A1D8161.2020009@hp.com> <0F5B06BAB751E047AB5C87D1F77A7788694630B931@GVW0547EXC.americas.hpqcorp.net> <451378.60037.qm@web32606.mail.mud.yahoo.com> <0F5B06BAB751E047AB5C87D1F77A7788694659AFB5@GVW0547EXC.americas.hpqcorp.net>
Date: Thu, 28 May 2009 13:48:18 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: "Miller, Mike \(OS Dev\)" <Mike.Miller@hp.com>,
       "Owens, James" <JOwens@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
       Kay Sievers <kay.sievers@vrfy.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A7788694659AFB5@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
> To: Martin Knoblauch <knobi@knobisoft.de>; "Owens, James" <JOwens@hp.com>
> Cc: Matthew Wilcox <matthew@wil.cx>; Andrew Morton <akpm@linux-foundation.org>; Mike Galbraith <efault@gmx.de>; "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>; "rjw@sisk.pl" <rjw@sisk.pl>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>; Kay Sievers <kay.sievers@vrfy.org>; "shemminger@vyatta.com" <shemminger@vyatta.com>; Jesse Barnes <jbarnes@virtuousgeek.org>
> Sent: Thursday, May 28, 2009 9:01:15 PM
> Subject: RE: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
> 
> 
> 
> > -----Original Message-----
> > From: Martin Knoblauch [mailto:knobi@knobisoft.de] 
> > Sent: Thursday, May 28, 2009 4:00 AM
> > To: Miller, Mike (OS Dev); Owens, James
> > Cc: Matthew Wilcox; Andrew Morton; Mike Galbraith; 
> > viro@ZenIV.linux.org.uk; rjw@sisk.pl; 
> > linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk; 
> > Kay Sievers; shemminger@vyatta.com; Jesse Barnes
> > Subject: Re: Analyzed/Solved/Bisected: Booting 
> > 2.6.30-rc2-git7 very slow
> > 
> > ----- Original Message ----
> > 
> > > From: "Miller, Mike (OS Dev)" 
> > > To: "Owens, James" ; Martin Knoblauch 
> > > 
> > > Cc: Matthew Wilcox ; Andrew Morton 
> > > ; Mike Galbraith ; 
> > > "viro@ZenIV.linux.org.uk" ; "rjw@sisk.pl" 
> > > ; "linux-kernel@vger.kernel.org" 
> > > ; "tigran@aivazian.fsnet.co.uk" 
> > > ; Kay Sievers ; 
> > > "shemminger@vyatta.com" ; Jesse Barnes 
> > > 
> > > Sent: Wednesday, May 27, 2009 8:18:46 PM
> > > Subject: RE: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very 
> > > slow
> > > 
> > > > > 
> > > > >  Finally, today I built the ccsii driver into the kernel. 
> > > > It was previously modularized and loaded from initrd. The second 
> > > > "sysfs" line went away. But does this make cciss guilty? 
> > It is now 
> > > > loaded about 2 seconds earlier in the boot sequence, 
> > which is a big 
> > > > change in timing I guess.
> > > > > 
> > > > >  Enlighten me :-)
> > > > 
> > > > No idea what is going on, but since I saw your May 20 message, I 
> > > > have been trying to wake up someone whose day job it should be to 
> > > > care about dl380s and smartarrays. :)
> > > 
> > > What? I know Martin has pinged me in the past, but I do not 
> > think it 
> > > was about this issue. If there's multiple sysfs entries for cciss I 
> > > can't explain that offhand. We do little to nothing for 
> > sysfs in the driver.
> > > Had something similiar happen recently where "/" changed to 
> > "!". Had 
> > > do to with our nested directory structure, /dev/cciss/name vs 
> > > /dev/name. But we did not make that change, either.
> > > 
> > Hi Mike, Jim
> > 
> >  you are right. I never talked to you about this issue. 
> > Actually, I did not suspect CCISS or the DL380 in general to 
> > be involved before last week when I retested on the x3650 and 
> > the problem went away. Due to day-job and priorities I did 
> > not follow up.
> 
> Martin,
> Same exact OS install? Are you sure all the userspace stuff is the same?
> 

 yup. Exactely same user-space. Same kernel config. Only difference is aacraid vs. cciss module in initrd

> -- mikem
> > > 
> > > > 
> > > > If they don't react soon, I'll make this my own day job to try to 
> > > > reproduce it.  We will need hardware config details and firmware 
> > > > revs to start.
> > > > 
> > 
> > Dl380/G4
> > 2x3.4 GHz CPUs
> > 8 GB Memeory
> > 4x72 GB as RAID5 on SA6i controller
> > 
> > BIOS: P51 (07(19/2007)
> > ILO FW: 1.91
> > SA6i FW: 2.84
> > 
> > lspci output (-vvv and -xxx) appendend to prevent line wrapping.
> > 
> > 
> > Cheers
> > Martin
> > 

