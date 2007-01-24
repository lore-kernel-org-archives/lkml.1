Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbXAXOhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbXAXOhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXAXOhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:37:12 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:20394 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbXAXOhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:37:10 -0500
X-AuditID: d80ac287-9e09dbb0000026f2-f4-45b770f9383b 
Date: Wed, 24 Jan 2007 14:37:23 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Chris Rankin <rankincj@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.18-stable release plans?
In-Reply-To: <20070124133037.98357.qmail@web52914.mail.yahoo.com>
Message-ID: <Pine.LNX.4.64.0701241425170.10956@blonde.wat.veritas.com>
References: <20070124133037.98357.qmail@web52914.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Jan 2007 14:37:10.0016 (UTC) FILETIME=[211F6000:01C73FC5]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, Chris Rankin wrote:
> 
> Personally, I dumped 2.6.19.x like a hot coal as soon as I tripped over this bug:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=7707
> 
> I didn't take much to trigger it, either. But the silence has been deafening.

Oh, the page_remove_rmap BUG, page_mapcount negative.

Sorry for the deafening silence, see I was CC'ed but dropped the ball.

That's surely no reason to dump 2.6.19.x, you'll find the occasional
such report on every(?) release since page mapcount went into 2.6.7.

Oftentimes it's bad RAM (try memtest86), sometimes it's a bad driver
(probably the case for the tainted P report appended to your untainted
one), sometimes it's unidentified memory corruption.  Not once (except
during experimental patch testing) has it been proved due to an actual
VM problem.

Hugh
