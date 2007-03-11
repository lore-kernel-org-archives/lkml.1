Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbXCKDp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbXCKDp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932857AbXCKDp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:45:26 -0500
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:44149 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932848AbXCKDpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:45:25 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: RSDL-mm 0.28
Date: Sun, 11 Mar 2007 14:44:52 +1100
User-Agent: KMail/1.9.5
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <20070311013506.GD10459@waste.org> <200703111459.28806.kernel@kolivas.org> <20070310193954.58389077.akpm@linux-foundation.org>
In-Reply-To: <20070310193954.58389077.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111444.53354.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 14:39, Andrew Morton wrote:
> > On Sun, 11 Mar 2007 14:59:28 +1100 Con Kolivas <kernel@kolivas.org> wrote:
> > > Bottom line: we've had a _lot_ of problems with the new yield()
> > > semantics. We effectively broke back-compatibility by changing its
> > > behaviour a lot, and we can't really turn around and blame application
> > > developers for that.
> >
> > So... I would take it that's a yes for a recommendation with respect to
> > implementing a new yield() ? A new scheduler is as good a time as any to
> > do it.
>
> I guess so.  We'd, err, need to gather Ingo's input ;)

cc'ed. Don't you hate timezones?

> Perhaps a suitable way of doing this would be to characterise then emulate
> the 2.4 behaviour.  As long as it turns out to be vaguely sensible.

It's really very simple. We just go the end of the current queued priority on 
the same array instead of swapping to the expired array; ie we do what 
realtime tasks currently do. It works fine here locally afaict.

-- 
-ck
