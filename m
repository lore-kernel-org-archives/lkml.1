Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbYEES7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbYEES7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760849AbYEES7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:59:07 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:15462 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759684AbYEES7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:59:05 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 20:59:00 +0200
User-Agent: KMail/1.9.9
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <200805022122.03576.elendil@planet.nl> <200805051932.41827.elendil@planet.nl> <200805051045.31026.jesse.barnes@intel.com>
In-Reply-To: <200805051045.31026.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805052059.01535.elendil@planet.nl>
X-OriginalArrivalTime: 05 May 2008 18:59:02.0105 (UTC) FILETIME=[152B2490:01C8AEE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, you wrote:
> On Monday, May 05, 2008 10:32 am Frans Pop wrote:
> > I suspect it could be vesafb/fbcon related instead. Normally I boot my
> > system with 'quiet vga=791', i.e. with vesafb. I then see the
> > artifacts.
> >
> > When I boot without 'vga=791', I hit another, unrelated regression
> > (which I'll report separately) [1].
> >
> > When I boot with 'video=vfb:off', I do _not_ get the artifacts when X
> > exits.
>
> Ahhh, I missed that part of your config.  That could definitely have an
> effect on things...  You'll probably want something like the attached

Not sure what to make of this.
With your patch I still get the artifacts, but they are displayed a lot 
shorter. I get only a flash instead of a-2 seconds.

> (there are other places in the fb layer that want similar treatment,
> iirc, maybe fb_pgprotect?).

Do you want to try a more complete review/patch or should this be punted 
over to the framebuffer folks?

Cheers,
FJP
