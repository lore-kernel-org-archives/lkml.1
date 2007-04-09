Return-Path: <linux-kernel-owner+w=401wt.eu-S965145AbXDITx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145AbXDITx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965109AbXDITx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:53:58 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:51664 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042AbXDITx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:53:57 -0400
Date: Mon, 9 Apr 2007 21:52:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [GIT PULL -mm] Unionfs branch management code
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Message-ID: <Pine.LNX.4.61.0704092149430.22295@yvahk01.tjqt.qr>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9 2007 10:53, Josef 'Jeff' Sipek wrote:
>
>The following patches introduce new branch-management code into Unionfs as
>well as fix a number of stability issues and resource leaks.  For detailed
>announcement, see end of this email.

I have to seriously ask: why don't we consider aufs? Without
readvertising its simple codebase, unionfs was (version 1.5pre) not
able to be used as a root filesystem when one of its branches is nfs.
(I figure I should build a testcase for that know that I had
a way to reproduce it for some time.)


Jan
-- 
