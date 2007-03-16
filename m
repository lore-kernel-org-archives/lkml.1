Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXCPX3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXCPX3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030321AbXCPX3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:29:10 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:44339 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030308AbXCPX3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:29:08 -0400
Date: Sat, 17 Mar 2007 00:27:27 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
In-Reply-To: <45FB24AC.6080804@nortel.com>
Message-ID: <Pine.LNX.4.61.0703170025210.23117@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <20070316141121.82ba7cb8.randy.dunlap@oracle.com>
 <20070316153957.232cf648.randy.dunlap@oracle.com> <45FB24AC.6080804@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 16 2007 17:13, Chris Friesen wrote:
>
> This would seem to be a bug in the build system then.  Or are you
> supposed to "make clean" after every config change?

No. When .config is changed, include/linux/config/ is updated, which
causes things that depends on it one or the other way to rebuild. At
least that is what I observed since ages.


Jan
-- 
