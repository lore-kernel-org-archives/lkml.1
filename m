Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbXENUUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbXENUUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758995AbXENUUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:20:00 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45032 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbXENUT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:19:59 -0400
Date: Mon, 14 May 2007 22:16:00 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Matt Mackall <mpm@selenic.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
In-Reply-To: <20070512124641.GZ11115@waste.org>
Message-ID: <Pine.LNX.4.61.0705142215130.9570@yvahk01.tjqt.qr>
References: <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org>
 <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org>
 <20070510004918.GS85884050@sgi.com> <46426D31.8070000@goop.org>
 <20070510012609.GU85884050@sgi.com> <46433049.4020003@goop.org>
 <20070510153832.GQ11115@waste.org> <Pine.LNX.4.61.0705121320240.9570@yvahk01.tjqt.qr>
 <20070512124641.GZ11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12 2007 07:46, Matt Mackall wrote:
>> 
>> You should not assume alphabetical order. Filesystems may be free to
>> reorder things and return them (1) randomly like in a hash (2) by
>> creation time during readdir().
>
>There is no assumption. Mercurial explicitly visits files in
>alphabetical order for the above commands.

But who says that

  for i in {a..z}; do  ## {..} is a bash3 extension
    touch $i;
  done;

actually makes readdir() return them in the same order?

	Jan
-- 
