Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbXCWNop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbXCWNop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 09:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934279AbXCWNop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 09:44:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934070AbXCWNon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 09:44:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcus Better <marcus@better.se>
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
Date: Fri, 23 Mar 2007 14:47:47 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, 0@ciao.gmane.org
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703221134.52481.marcus@better.se> <eu05p3$u20$1@sea.gmane.org>
In-Reply-To: <eu05p3$u20$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703231447.47741.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 23 March 2007 10:14, Marcus Better wrote:
> Marcus Better wrote:
> > The XFS workqueue patch [1] fixes my problem [2].
> 
> > [1] http://permalink.gmane.org/gmane.linux.kernel/507616
> > [2] http://permalink.gmane.org/gmane.linux.kernel/505570
> 
> Unfortunately it only fixed suspend to RAM. Suspend to disk still hangs
> at "snapshotting system". Will try to bisect it...

Do you use the microcode driver?

Rafael
