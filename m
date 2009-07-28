Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZG1DM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZG1DM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 23:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZG1DM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 23:12:27 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:64178 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZG1DM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 23:12:26 -0400
X-Greylist: delayed 2167 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 23:12:26 EDT
To: davidn@davidnewall.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Regression impacts ServeRAID II on IBM xSeries 5500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A69D341.8030908@davidnewall.com>
References: <4A6172F0.60707@davidnewall.com>
	<20090723110118N.fujita.tomonori@lab.ntt.co.jp>
	<4A69D341.8030908@davidnewall.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090728114207C.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 28 Jul 2009 11:42:07 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009 00:59:05 +0930
David Newall <davidn@davidnewall.com> wrote:

> >> My machine and assistance is at your disposal.  Rather than guess what
> >> information you want: what can I tell you?
> >>     
> >
> > What kernel version do you use, the latest git tree?
> 
> I was running Ubuntu's 2.6.28-13-server, but have reverted to their
> 2.6.27-10-server, that being the latest Ubuntu-provided version on which
> ipssend works. The patch which apparently introduced the regression is
> for 2.6.27-rc9, which is quite old. The regression was a year ago, and
> although I've found quite a few people who have the same problem, I
> haven't found any indication of the problem having been previously
> reported or bisected, so it's likely the latest version still has the
> problem. I am happy to try the latest version of you want.

I merged lots of changes to sg in 2.6.28. I fixed several bugs due to
it (the last one was merged in 2.6.31-rc3). Can you try the
2.6.31-rc4?
