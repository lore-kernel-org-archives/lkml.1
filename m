Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZGIUDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZGIUDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZGIUCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:02:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbZGIUCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:02:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>, johannes@sipsolutions.net
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of b44/b43 modules
Date: Thu, 9 Jul 2009 22:03:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Tomas Janousek" <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <87k52izvd9.fsf@scholz.fias.uni-frankfurt.de> <87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
In-Reply-To: <87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907092203.10294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 July 2009, Jan Scholz wrote:
> Hi,
> 
> I have just checked this on v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547
> (I wanted to test this on v2.6.31-rc2 as well, but there I had other
> suspend-issues that are fixed in todays v2.6.31-rc2-214-g34f2547)
> 
> For both v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547 suspend to ram fails
> with the test procedure described below, but it works fine when I revert
> commit 5bb644a0fd25a5e083ecbfaa92a211db99aa6ef7
>  "mac80211: cancel/restart all timers across suspend/resume"

Thanks for the update.

Johannes, do you have any idea what can go wrong here?

Rafael
