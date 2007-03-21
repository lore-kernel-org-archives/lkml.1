Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXCUSfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXCUSfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCUSfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:35:08 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39013
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351AbXCUSfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:35:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: 2.6.21-rc4-mm1
Date: Wed, 21 Mar 2007 19:34:28 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
       John Linville <linville@tuxdriver.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320223643.d8cbc3f6.akpm@linux-foundation.org> <4601761F.4000302@lwfinger.net>
In-Reply-To: <4601761F.4000302@lwfinger.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703211934.28465.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 19:14, Larry Finger wrote:
> Andrew Morton wrote:
> > On Tue, 20 Mar 2007 17:23:54 -0600 Zan Lynx <zlynx@acm.org> wrote:
> > 
> >> On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
> >>> Temporarily at
> >>>
> >>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> >>>
> >>> Will appear later at
> >>>
> >>>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> >> First impressions:
> >> Several of the same bugs as rc3-mm*:
> >>       * Freezes immediately if I touch the wlan0 device after loading
> >>         the new Broadcom wireless driver.
> 
> The version of the ssb driver in 2.6.21-rc4-mm1 has a bug that causes a kernel oops if the bcm43xx
> chip contains a USB (dangling) core. This bug has been fixed in Michael Buesch's tree, but
> apparently not yet in Linville's wireless-dev tree. The patch is as follows:
> 
> commit 08531ff130bcc8181d9294a66e25010f48eefb97
> Author: Michael Buesch <mb@bu3sch.de>
> Date:   Wed Mar 7 23:01:08 2007 +0100
> 
>     ssb: Don't freeze unregistered devices.

No, that's a different fix for suspend.

This is the fix:
http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=b87f743f3643ea162892dce0bbc91e6f026a49bf

Pull request was sent to John.

-- 
Greetings Michael.
