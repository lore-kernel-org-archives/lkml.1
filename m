Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbXIJSLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbXIJSLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 14:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXIJSKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:10:52 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:57662 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750700AbXIJSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:10:52 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [RESEND][PATCH 0/4] Virtual Machine Time Accounting
Date: Mon, 10 Sep 2007 19:10:36 +0100
User-Agent: KMail/1.9.7
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46E5325D.1020902@bull.net> <46E53D96.4050409@qumranet.com> <46E541DD.4080202@bull.net>
In-Reply-To: <46E541DD.4080202@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709101910.36923.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2007 14:08:45 Laurent Vivier wrote:
> Avi Kivity wrote:
> > Ingo Molnar wrote:
> >> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> >>> Ingo, please, could you have a look to these patches ?
> >>>
> >>> The aim of these four patches is to introduce Virtual Machine time
> >>> accounting.
> >>>
> >>> [PATCH 1/4] as recent CPUs introduce a third running state, after
> >>> "user" and "system", we need a new field, "guest", in cpustat to
> >>> store the time used by the CPU to run virtual CPU. Modify /proc/stat
> >>> to display this new field.
> >>
> >> the concept certainly looks sane to me.
> >>
> >> The heavy-handed use of #ifdefs uglifies the code to a large degree,
> >> but this is not a fundamental problem: since basically all distros
> >> have KVM enabled (and lguest benefits from this too), could you just
> >> make all this new code unconditional?
> >
> > I imagine the embedded people will complain... perhaps move all the code
> > to a #ifdef section above with a full implementation and a stub
> > implementation.
>
> I'm going to repost patches without #ifdefs for readability.
> Then we could discuss if we should introduce #ifdefs and how.

If you could provide a summary of the size increase from your latest post 
(i.e., size of the kernel before and after) that might lay rest to some 
theoretical complaints.

This doesn't look like enough code to warrant ifdefs.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

