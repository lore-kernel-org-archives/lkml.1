Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZBPNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZBPNBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZBPNBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:01:13 -0500
Received: from welcomes-you.com ([85.214.50.128]:33371 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbZBPNBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:01:12 -0500
Message-ID: <49996380.1090902@aei.mpg.de>
Date: Mon, 16 Feb 2009 14:00:48 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       beowulf@beowulf.org
Subject: Re: Tracing down 250ms open/chdir calls
References: <49991BE7.1090104@aei.mpg.de> <1234788998.7708.40.camel@heimdal.trondhjem.org>
In-Reply-To: <1234788998.7708.40.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

Trond Myklebust schrieb:
> 2.6.27.7 has a known NFS client performance bug due to a change in the
> authentication code. The fix was merged in 2.6.27.9: see the commit
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git&a=commitdiff&h=a0f04d0096bd7edb543576c55f7a0993628f924a

Maybe that's also a reason why we don't see it that often anymore -
although the user load has shifted a bit also. We are running 2.7.27.14
(and .15 since Friday).

Thanks for letting me know, I'll probably re-run the tests again with a
newer kernel.

Cheers

Carsten
