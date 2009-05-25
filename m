Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZEYJ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZEYJ0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZEYJ0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:26:04 -0400
Received: from mail.crca.org.au ([67.207.131.56]:52731 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbZEYJ0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:26:03 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090509135820.GF10859@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905082144.57955.bzolnier@gmail.com>
	 <1241819971.19600.288.camel@nigel-laptop>
	 <200905090105.58243.bzolnier@gmail.com>
	 <1241824525.19600.369.camel@nigel-laptop>
	 <20090509135820.GF10859@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 25 May 2009 19:27:46 +1000
Message-Id: <1243243666.16743.64.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2009-05-09 at 15:58 +0200, Pavel Machek wrote:
> Hi!
> 
> > > Instead of new features I would rather see more effort being put into making
> > > the _core_ TuxOnIce (I mean patch #8 here) smaller (8 KLOC is still a lot,
> > > just to put things into the right perspective the current in-kernel content
> > > of kernel/power/ is 5.5 KLOC) and with more documentation inside the code.
> > 
> > Yeah, but those 2.5k extra lines get you more reliability and extra
> > functionality. They're not fat.
> 
> If you know about reliability problems in swsusp, please fix them in
> separate patch. Hiding the fixes in 8KLOC patch is not nice.

I'm going to try to. Unfortunately, they'll require what's basically a
group-up redesign of the basic algorithm, because to get maximum
reliability, you need to carefully account for the amount of storage
you're going to need and the amount of memory you have available, and
'prepare' the image prior to doing the atomic copy.

Regards,

Nigel

