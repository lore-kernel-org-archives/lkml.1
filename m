Return-Path: <linux-kernel-owner+w=401wt.eu-S1763569AbXH3Wg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763569AbXH3Wg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbXH3Wgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:36:49 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39952
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762469AbXH3Wgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:36:49 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
Date: Thu, 30 Aug 2007 18:36:48 -0500
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, werner@almesberger.net, hpa@zytor.com
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com> <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301836.48707.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 1:28:17 pm Robert P. J. Day wrote:
> On Thu, 30 Aug 2007, Randy Dunlap wrote:
>
> ...
>
> > The old "ramdisk=<ram_size>" has been changed to
> > "ramdisk_size=<ram_size>" to make it clearer.  The original
> > "ramdisk=<ram_size>" has been kept around for compatibility reasons,
> > but it may be removed in the future.
>
> ...
>
> i just the other day submitted a patch to remove that backward
> compatibility, and the m68k portion of it has already been acked by
> geert uytterhoeven.

Could you mention it in feature-removal-schedule.txt?  (People check that for 
warning of upcoming changes that impact existing code.  They may not notice 
something elsewhere after they've got it working...)

(Also, sorting feature-removal-schedule.txt by date would be really nice.  The 
sucker's gotten huge...)

And while I'm looking at this, is there some other place that entries in this 
file go once they _have_ been removed, so people can see "oh yeah, that went 
away in 2.6.23) when they try to install 2.6.25?  If there is, I missed it.  
Maybe http://lwn.net/Articles/2.6-kernel-api/ is good enough, but this seems 
easy to do in Documentation...

Thanks,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
