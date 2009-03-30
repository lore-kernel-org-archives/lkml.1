Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZC3MDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZC3MDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZC3MDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:03:05 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:62503 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZC3MDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:03:04 -0400
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 08:03:03 EDT
To: hias@horus.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [Bug #12612] hard lockup when interrupting cdda2wav
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090328141125.GA4061@horus.com>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
	<fnEpM0mQZjO.A.kXF.l8TxJB@chimera>
	<20090328141125.GA4061@horus.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090330204051K.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 30 Mar 2009 20:40:51 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 15:11:25 +0100
Matthias Reichl <hias@horus.com> wrote:

> On Sat, Mar 21, 2009 at 06:07:27PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12612
> > Subject		: hard lockup when interrupting cdda2wav
> > Submitter	: Matthias Reichl <hias@horus.com>
> > Date		: 2009-01-28 16:41 (53 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
> > Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Patch		: http://marc.info/?l=linux-scsi&m=123371501613019&w=2
> 
> The bug is still present in 2.6.28.9 and in 2.6.29 (see backtraces
> below).

The patch has been in James' scsi-misc tree. It was finally merged
into mainline. So I've just sent it to stable@kernel.org.
