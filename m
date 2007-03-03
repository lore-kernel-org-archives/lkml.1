Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXCCVLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXCCVLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbXCCVLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:11:19 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50773
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXCCVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:11:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: do not rebuild when kernel version changes
Date: Sat, 3 Mar 2007 22:10:31 +0100
User-Agent: KMail/1.9.5
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <20070303190328.GA30463@uranus.ravnborg.org> <200703032121.43136.mb@bu3sch.de> <45E9E2BD.9070106@lwfinger.net>
In-Reply-To: <45E9E2BD.9070106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703032210.31546.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007 22:03, Larry Finger wrote:
> Michael Buesch wrote:
> > On Saturday 03 March 2007 20:03, Sam Ravnborg wrote:
> >> Replacing use of UTS_RELEASE with utsname()->release
> >> avoids that this module is rebuild each
> >> time the kernel version changes.
> >>
> >> Compile tested only.
> > 
> > I vote to get rid of the whole bcm43xx_ethtool.c file, as it's useless.
> > It will vanish with the advent of d80211, anyway.
> > Larry?
> 
> Is bcm43xx_ethtool.c really useless?

Yes it is useless.
1) There isn't really anything ethtool related implemented. Just the useless info stuff.
2) ethtool is rather useless for wireless in general (that's why there isn't
   anything implemented ;) )

Please remove the file, kill it from Makefile and remove the ethtool
ops set in main.c (one line).

-- 
Greetings Michael.
