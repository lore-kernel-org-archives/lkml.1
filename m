Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYBYXsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYBYXsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbYBYXsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:48:39 -0500
Received: from sandeen.net ([209.173.210.139]:29548 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbYBYXsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:48:39 -0500
Message-ID: <47C353D4.1060501@sandeen.net>
Date: Mon, 25 Feb 2008 15:48:36 -0800
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] filesystem corruption on xfs after 2.6.25-rc1 (bisected,
 powerpc related?)
References: <20080225112310.GA5516@soziologie.ch> <47C305BD.1060408@sandeen.net> <200802260042.35918.rjw@sisk.pl>
In-Reply-To: <200802260042.35918.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 25 of February 2008, Eric Sandeen wrote:


>> If you're feeling motivated, maybe you can narrow it down to which of
>> the changes - xfs_highbit32, xfs_highbit64, xfs_lowbit32, or
>> xfs_lowbit64 - is causing the problem?  (or maybe they all are ...)
>>
>> Or maybe someone looking at the commit can immediately see the
>> problem... but I can't :)
> 
> Well, IMO a reproducible filesystem corruption is a serious enough issue
> for reverting all of the commits in question.

I'm not suggesting a partial revert; I just wonder which part of the
change is causing the problem, as part of the debugging process.

-Eric
