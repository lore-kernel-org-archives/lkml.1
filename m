Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbYD3OMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbYD3OMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbYD3OMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:12:39 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:59018 "EHLO
	kirsi1.rokki.sonera.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756305AbYD3OMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:12:38 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 10:12:38 EDT
Date: Wed, 30 Apr 2008 17:06:04 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux 2.6.24.4+mmap with overcommit >= 1
Message-ID: <20080430140604.tic7mhvu35xbjacb@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080430011953.c5ftilonkabvwmkp@m.safari.iki.fi> <20080430112453.406b243a@core> <20080430114737.ihnza5eigafftkub@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430114737.ihnza5eigafftkub@m.safari.iki.fi>
User-Agent: Mutt/1.5.17 (2008-03-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 14:47:38 +0300, Sami Farin wrote:
> On Wed, Apr 30, 2008 at 11:24:53 +0100, Alan Cox wrote:
> > On Wed, 30 Apr 2008 04:19:54 +0300
> > Sami Farin <safari-kernel@safari.iki.fi> wrote:
> > 
> > > I have arch x86_64, glibc-2.7.90-7 from Fedora.
> > > When I have vm.overcommit_memory == 1 or 2,
> > > mmap succeeds for really huge values.
> > > These ranges succeed (approximate):
> > >  8793870000000 - 17500387000000
> > > 26390387000000 - 35180387000000
> > 
> > Fun fun fun
> > 
> > This should fix strict overcommit (== 2) I think
> 
> Thanks, one more reason to boot to 2.6.24.5...
> 
> This patch needed, too, I guess.

Booted.  Works great.

$ ./a.out 30390387000000
trying 30390387000000 bytes... got (nil)

-- 
Do what you love because life is too short for anything else.

