Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYCDTnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYCDTnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYCDTm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:42:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765937AbYCDTm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:42:27 -0500
Date: Tue, 04 Mar 2008 14:42:40 -0500 (EST)
Message-Id: <20080304.144240.71085240.k-ueda@ct.jp.nec.com>
To: w41ter@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] block: fix residual byte count handling
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <fqk15l$lgq$1@ger.gmane.org>
References: <1204634238.5997.5.camel@homer.simson.net>
	<20080304123939.GM6704@kernel.dk>
	<fqk15l$lgq$1@ger.gmane.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 04 Mar 2008 09:34:56 -0800, walt wrote:
> Jens Axboe wrote:
> > On Tue, Mar 04 2008, Mike Galbraith wrote:
> >> On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> >>
> >>> Looks excellent to me, has a variant of this been tested as OK by the
> >>> users reporting the regression?
> >> K3b burning seems to be a nogo here.  This is git pulled this morning
> >> though, so it's a somewhat different tree than previously tested fwtw.
> >
> > can you please try git as of this morning without any patches applied,
> > and then pull
> >
> > git://git.kernel.dk/linux-2.6-block.git for-linus
> >
> > into that and see if that works?
> 
> Unfortunately this doesn't fix a problem I've discussed off-list with
> Kiyoshi Ueda, who suggested that I should follow this thread and try
> any patches posted here.
 
I think there was misunderstanding between us.
On off-list, I meant:
  o Your original problem was CD burning, and it looked same problem
    being discussed on this thread, according to this message:

> cdrecord: Warning: controller returns zero sized CD capabilities page.
> cdrecord: Warning: controller returns wrong page 0 for CD capabilities page (2A). 

    So I suggested you to watch this thread and try patches of this
    thread for CD burning problem.

  o The problem of ide_cd_check_ireason looked different from
    CD burning one.
    So I suggested you to report it as a different problem.

Thanks,
Kiyoshi Ueda
