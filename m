Return-Path: <linux-kernel-owner+w=401wt.eu-S1422747AbXCWJOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422747AbXCWJOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 05:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422748AbXCWJOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 05:14:40 -0400
Received: from main.gmane.org ([80.91.229.2]:52274 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422747AbXCWJOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 05:14:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
Followup-To: gmane.linux.kernel
Date: Fri, 23 Mar 2007 10:14:11 +0100
Message-ID: <eu05p3$u20$1@sea.gmane.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <eto9sh$262$1@sea.gmane.org> <1174485863.10840.80.camel@localhost.localdomain> <200703221134.52481.marcus@better.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 67.152.216.81.static.g-va.siw.siwnet.net
User-Agent: KNode/0.10.4
Cc: 0@ciao.gmane.org, 0@ciao.gmane.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Better wrote:
> The XFS workqueue patch [1] fixes my problem [2].

> [1] http://permalink.gmane.org/gmane.linux.kernel/507616
> [2] http://permalink.gmane.org/gmane.linux.kernel/505570

Unfortunately it only fixed suspend to RAM. Suspend to disk still hangs
at "snapshotting system". Will try to bisect it...

Marcus


