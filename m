Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZFDIJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZFDIJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZFDIJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:09:00 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25732 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbZFDII7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:08:59 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: sound tree build failure
Date: Thu, 4 Jun 2009 11:08:13 +0300
User-Agent: KMail/1.11.3 (Linux/2.6.29-gentoo-r5; KDE/4.2.3; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <20090604173342.b7dbca6d.sfr@canb.auug.org.au> <s5hk53s4e9w.wl%tiwai@suse.de>
In-Reply-To: <s5hk53s4e9w.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906041108.13829.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 04 Jun 2009 08:08:11.0252 (UTC) FILETIME=[9A371B40:01C9E4EB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009 11:03:07 ext Takashi Iwai wrote:
> At Thu, 4 Jun 2009 17:33:42 +1000,
>
> Stephen Rothwell wrote:
> > Hi Takashi,
> >
> > Today's linux-next build (powerpc allyesconfig) failed like this:
> >
> > sound/soc/codecs/twl4030.c: In function 'twl4030_read_reg_cache':
> > sound/soc/codecs/twl4030.c:152: error: 'cache' undeclared (first use in
> > this function)
> >
> > Caused by commit 16a30fbb0d3aa4ee829a2dd3d0e314e2b5ae96a9 ("ASoC:
> > TWL4030: Use reg_cache in twl4030_init_chip").
> >
> > I reverted that commit for today.
>
> Thanks.  It's likely a cut-and-paste error in that commit.
> I fixed now on sound git tree.

Yes, it was a cut-and-paste error. I have also made the patch to fix it.
I'll not send it, thanks Takashi for fixing it.

It is so embarrassing, since this is the second time that my patch broke the 
linux-next build.
I'll try to be even more careful in the future.

Again, sorry about this.

>
> Takashi

-- 
Péter
