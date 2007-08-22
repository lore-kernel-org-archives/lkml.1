Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbXHVV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbXHVV62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932324AbXHVV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:58:11 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59075
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbXHVV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:58:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.23-rc3-mm1: fix b43 compilation
Date: Wed, 22 Aug 2007 23:56:43 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708221833.59375.rjw@sisk.pl>
In-Reply-To: <200708221833.59375.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708222356.44088.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2007 18:33:58 Rafael J. Wysocki wrote:
> On Wednesday, 22 August 2007 11:06, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > 
> > - git-ixgbe.patch got dropped - git-net.patch destroyed it
> > 
> > - then git-net got dropped as it doesn't work
> 
> Apparently, the b43 driver is expecting another version of mac80211.
> 
> This patch fixes the compilation, but I'm not sure what about the
> functionality. ;-)

There seems to be a screwup somehow.
These mac80211 API functions were recently changed to include
the additional parameter. So it seems you carry an old version of mac80211.

-- 
Greetings Michael.
