Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZBZRkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZBZRkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZBZRkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:40:35 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57842 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751972AbZBZRke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:40:34 -0500
Date: Thu, 26 Feb 2009 18:40:31 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Mark Nelson <markn@au1.ibm.com>
cc: linuxppc-dev@ozlabs.org, Jan Kara <jack@ucw.cz>, Jan Kara <jack@suse.cz>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
In-Reply-To: <200902261020.34325.markn@au1.ibm.com>
Message-ID: <alpine.LRH.2.00.0902261805510.29190@vixen.sonytel.be>
References: <49A2705D.9030008@in.ibm.com> <alpine.LRH.2.00.0902251430410.4063@vixen.sonytel.be> <200902260945.41990.markn@au1.ibm.com> <200902261020.34325.markn@au1.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Mark Nelson wrote:
> On Thu, 26 Feb 2009 09:45:41 am Mark Nelson wrote:
> > On Thu, 26 Feb 2009 12:31:20 am Geert Uytterhoeven wrote:
> > > On Wed, 25 Feb 2009, Mark Nelson wrote:
> > > > Does the following patch fix the errors you're seeing? (it applies the
> > > > same fix as the previous patch but this time to copy_tofrom_user, which
> > > > I updated in a4e22f02f5b6518c1484faea1f88d81802b9feac)
> > > 
> > > Thanks, but I still get crashes in copy_page_range().
> > 
> > Hmmm... I'm out of ideas for the moment, but thanks for testing anyway!
> 
> If you revert both 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556 and
> a4e22f02f5b6518c1484faea1f88d81802b9feac, does it help? You could also
> try to revert 57dda6ef5bd5b9e60410477ad29e654097e2cca1 just in case I
> need to keep wearing the brown paper bag for a bit longer :)

Still doesn't help.

However, I noticed I never enabled CONFIG_DEBUG_PAGEALLOC before 2.6.29-rc5.
So far I tried 2.6.2[5-8], and they all crash with CONFIG_DEBUG_PAGEALLOC.
I guess it never actually worked on PS3.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
