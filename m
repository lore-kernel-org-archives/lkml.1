Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZJ0Myk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZJ0Myk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 08:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbZJ0Myk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 08:54:40 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:55528 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168AbZJ0Myh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 08:54:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Michael Guntsche <mike@it-loops.com>
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Date: Tue, 27 Oct 2009 11:38:00 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
References: <20091027095014.GA22215@gibson.comsick.at>
In-reply-To: <20091027095014.GA22215@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910271138.01624.elendil@planet.nl>
X-OriginalArrivalTime: 27 Oct 2009 12:54:40.0842 (UTC) FILETIME=[A5E822A0:01CA5704]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Guntsche wrote:
> I noticed that I get page alloc errors on one of my machines.
> It is an old server I use as a fileserver with 512MB RAM. Before
> 2.6.3[12] I did not see this problem at all.
> This only seems to happens when I use mutt on this machine.
> I know that it means I am running out of memory here, but I am wondering
> why I did not see this before....
> 
> mutt: page allocation failure. order:1, mode:0x20
> Pid: 21746, comm: mutt Not tainted 2.6.32-rc5 #2

This is a known issue that's being heavily investigated, but is proving 
very elusive. See http://lkml.org/lkml/2009/10/22/128 for an overview.

Can you easily reproduce the problem, or does it happen at random moments? 
If you can reproduce it, it would be great if you could test the patches 
mentioned in that mail.

Cheers,
FJP
