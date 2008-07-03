Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYGCMsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYGCMsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYGCMsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:48:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYGCMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:48:21 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: David Woodhouse <dwmw2@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, Kay Sievers <kay.sievers@vrfy.org>, arjan@infradead.org
In-Reply-To: <65663.1215080245@turing-police.cc.vt.edu>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	 <1215077028.10393.497.camel@pmac.infradead.org>
	 <65663.1215080245@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 11:30:29 +0100
Message-Id: <1215081029.10393.517.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 06:17 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 03 Jul 2008 10:23:48 BST, David Woodhouse said:
> 
> > The recent firmware changes haven't modified this. The important change
> > seems to have been here (in 2006):
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a30a6a2c
> 
> Aha. That's the part I was missing. :)
> 
> From the changelog for that commit, Shaohua Li wrote:
> 
> "with the changes, we should put all intel-ucode/xx-xx-xx microcode files
> into the firmware dir (I had a tool to split previous big data file into
> small one and later we will release new style data file).  The init script
> should be changed to ..."
> 
> And apparently I got stuck between the unreleased tool to split the file,
> and the release of the new style data file.

That 'new style' data file is just the binary output of the
microcode_ctl tool. The kernel is still capable of finding the section
it requires, when fed the whole blob.

> Anyhow, it appears the firmware_request() was just a bullet loaded in the
> chamber waiting for me to pull the trigger 2 years later by setting
> CONFIG_FIRMWARE_IN_KERNEL=n :)

No, the recent firmware changes haven't modified this. The
FIRMWARE_IN_KERNEL option makes no difference here.

> The behavior is explained, and presumably Intel will eventually release
> a method of getting the new-format bits, and all will be right with the
> world (or at least this part of it.. ;)

Some would say that Intel already released a method for making it work,
in the form of the email to which you're replying... does that udev
configuration not work for you?

-- 
dwmw2

