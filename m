Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYKIEZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYKIEZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 23:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYKIEZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 23:25:26 -0500
Received: from mx2.adfa.edu.au ([131.236.200.17]:6538 "EHLO mx2.adfa.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbYKIEZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 23:25:25 -0500
X-Greylist: delayed 687 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Nov 2008 23:25:24 EST
X-IronPort-AV: E=Sophos;i="4.33,568,1220191200"; 
   d="scan'208";a="66929"
Date: Sun, 9 Nov 2008 15:13:39 +1100
From: Stephen Harker <sjh@adfa.edu.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: s.harker@adfa.edu.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: PROBLEM: module a100u2w (SCSI, Initio) on ppc
Message-ID: <20081109041339.GA6188@h42148.pems.adfa.edu.au>
Reply-To: Stephen Harker <s.harker@adfa.edu.au>
References: <20080712033040.GA8086@h42136.pems.adfa.edu.au> <20080711220901.e1b69adb.akpm@linux-foundation.org> <20080715233044N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715233044N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.2i
X-Attribution: Stephen Harker
X-Organisation: PEMS, UNSW@ADFA, Australia
X-Phone: +61 3 9905 3632
X-FAX: +61 3 9905 3637
X-Operating-System: Linux h42148.pems.adfa.edu.au 2.6.25.10
Delivery-Receipt-To: "s.harker@adfa.edu.au (Stephen Harker)"
X-OriginalArrivalTime: 09 Nov 2008 04:13:55.0199 (UTC) FILETIME=[94A560F0:01C94221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:30:27PM +0900, FUJITA Tomonori wrote:
> On Fri, 11 Jul 2008 22:09:01 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > (cc linux-scsi)
> > 
> > On Sat, 12 Jul 2008 13:30:41 +1000 Stephen Harker <s.harker@adfa.edu.au> wrote:
> [...]
> Seems that this driver has some bugs on big endian architectures
> (though I've not looked at the patch):
> 
> http://marc.info/?l=linux-scsi&m=121613124207253&w=2

I realised I had not replied to this email.  With this patch the
driver works fine.  I now have both drives on the Initio SCSI bus and
am running Linux (Yellow Dog), OSX and OS9 with no problems.  A rough
timing attempt (hdparm -t) gave something like 18 MB/sec for the IBM
UltraStar and around 35 MB/sec for the Cheetah.  This is a big
improvement over the built in MESH with its limit of 10 MB/sec!

-- 
Stephen Harker                           s.harker@adfa.edu.au
PEMS
UNSW@ADFA
