Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbXEaTxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbXEaTxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760978AbXEaTxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:53:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49780 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760855AbXEaTxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:53:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 21:58:25 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <465EE9F2.8080905@googlemail.com>
In-Reply-To: <465EE9F2.8080905@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705312158.26560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 May 2007 17:29, Michal Piotrowski wrote:
> Hi,
> 
> Andrew Morton napisał(a):
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> > 
> 
> FYI suspend to disk doesn't work anymore on my box, system hangs after "Suspending console(s)" message.
> 
> [  186.297753] Shrinking memory...  -\|/-\|done (113064 pages freed)
> [  187.841914] Freed 452256 kbytes in 1.54 seconds (293.67 MB/s)
> [  187.847730] Suspending console(s)
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/console.log
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/mm-config

Hmm, that might be a couple of things, actually.

To see if the patches directly related to hibernation/suspend cause this, can
you please test 2.6.22-rc3 with the patch series at

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/

applied?

Greetings,
Rafael
