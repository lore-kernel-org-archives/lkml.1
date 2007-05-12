Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXELL11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXELL11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXELL1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:27:20 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39093 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbXELL1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:27:20 -0400
Date: Sat, 12 May 2007 13:23:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Chuck Ebbert <cebbert@redhat.com>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
In-Reply-To: <46439491.9010604@goop.org>
Message-ID: <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com>
 <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com>
 <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org>
 <464393E1.3050705@redhat.com> <46439491.9010604@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 14:54, Jeremy Fitzhardinge wrote:
>>>> What CPU architecture is this happening on? Not i686 with PAE by
>>>> any chance?
>>>>       
>>> Yes.  Why?
>>
>> I have a bug report where NFS files are corrupted only with PAE clients.
>> Corruption is at the end of the (newly untarred) files. Doesn't happen
>> without PAE.
>
>Hm, suggestive, but I'm not convinced.  Two differences to this situation:
>
>   1. Immediately after the clone ("untar"), the contents are completely
>      OK; it's only after a umount/mount cycle to problems appear

And if you do a "sync" rather than umount/mount?

>   2. There's no corruption as such; the files are just too short.  And
>      it seems they're at a previously OK length, not some random size.


	Jan
-- 
