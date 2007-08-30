Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXH3RHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXH3RHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXH3RHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:07:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:42771 "EHLO
	viefep24-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932698AbXH3RHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:07:33 -0400
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: Linux 2.6.23-rc4: BAD regression
Date: Thu, 30 Aug 2007 19:07:55 +0200
User-Agent: KMail/1.9.6
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch> <20070829232150.GA17467@dreamland.darkstar.lan>
In-Reply-To: <20070829232150.GA17467@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301907.56561.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 01:21:50 Luca Tettamanti wrote:
> Il Wed, Aug 29, 2007 at 01:29:56AM +0200, Daniel Ritz ha scritto: 
> > tried that one on my old toshiba tecra 8000 laptop, almost killing it.
> > the fan doesn't work any more...type 'make' and see the box dying.
> > luckily my CPU doesn't commit suicide...bisected it to that one:
> > 
> > cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b is first bad commit
> 
> I've just bisected down to the same commit. In my case the fan is locked
> at maximum speed and the system is *extremly* slow (some kind of
> throttling?).
> 
> Alexey, I've seen the patch, I'll test it tomorrow and report back.
> 

i've just tested the minimal fix here:
	http://bugzilla.kernel.org/show_bug.cgi?id=8958#c7
works good so far. fan starts and system is responsive.

> Luca

rgds
-daniel


