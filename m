Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbXETHlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbXETHlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760232AbXETHlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:41:01 -0400
Received: from web52604.mail.re2.yahoo.com ([206.190.48.207]:31066 "HELO
	web52604.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760094AbXETHlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:41:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=IWX1UEeQD2VG8pevO5AoDZjNnf0zZ0B8/diSkBmpql06ocdZNxDwJ3srP1Xo8d/z2A8YlBA5VuwcAd73ZhINW7NlDMBV1Adi18J+1lMvWf5FQafETTOjwb+Ct1sNPFUwP0bhAstHjwUPVQdPFt4/E9EkeyL7YyCRXoN36qeb2UY=;
X-YMail-OSG: iOmLLGQVM1mZm4z3yslgp2fM9qyuiee2pWPw_gVp_9p0.aibzlo0GOKjv.2c8jjFUw--
Date: Sun, 20 May 2007 17:40:56 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705200011200.18989@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <380486.61048.qm@web52604.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Christoph Lameter <clameter@sgi.com> wrote:
> On Sun, 20 May 2007, Srihari Vijayaraghavan wrote:
> 
> > Code: 0f ob eb fe 48 8b 1b 48 8b 0x 0f 18 08 48 81 fb 60 cb 51 80
> > RIP [...] slab_sysfs_init+0x49/0x98
> > RSP [...]
> > kernel panic - not syncing: Attempted to kill init!
> 
> sysfs? If you build without CONFIG_SLUB_DEBUG then SLUB will not use 
> sysfs. You can switch that off in the embedded section.

Fair enough. Would you the section name it appears in 'menuconfig'?

I looked under 'Kernel hacking' section (where the slab debugging appears if
slab is turned on as 'Debug slab memory allocation') & in the 'General setup'
section also. I unable to figure out how to disable slub debugging :-(.

Pls give me a pointer to it.

Thanks

(Won't it be right to disable it by default when a user selects slub such that
a user needs to manually turn on the slub debugging in menuconfig?)



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

