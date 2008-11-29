Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYK2NCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYK2NCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 08:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYK2NCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 08:02:06 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37200 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYK2NCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 08:02:05 -0500
Date: Sat, 29 Nov 2008 14:03:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Eric Miao <ymiao3@marvell.com>,
       rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
Message-ID: <20081129130329.GA13867@uranus.ravnborg.org>
References: <1227606164-12659-1-git-send-email-mike@compulab.co.il> <E913911567467945BBEB9277E27868B00153DC31@msiexch01.marvell.com> <492BCD01.7080508@compulab.co.il> <f17812d70811260012n57e89eb9q1101fa1e13813a49@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70811260012n57e89eb9q1101fa1e13813a49@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 04:12:07PM +0800, Eric Miao wrote:
> Sam,
> 
> Do you have any suggestion to this?
> 
[snip two modules with same name does not work...]

kbuild today create one file for each module in the
directory: .tmp_versions/

So in this case the module that is build lst is the winner.

I do not see any easy way to avoid this.
What we could do:
1) find another way to record what modules we have
2) embed path in filename

I did not try to actually implement any of the above
as the gain seems minimal compared to the additional complexity.

	Sam
