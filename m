Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYKDQm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYKDQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYKDQms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:42:48 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:59682 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbYKDQms convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:42:48 -0500
From: Frans Pop <elendil@planet.nl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] rtc-cmos: Fix boot log message
Date: Tue, 4 Nov 2008 17:42:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200811031942.20360.elendil@planet.nl> <200811031952.39423.elendil@planet.nl> <200811031506.42247.david-b@pacbell.net>
In-Reply-To: <200811031506.42247.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811041742.45285.elendil@planet.nl>
X-OriginalArrivalTime: 04 Nov 2008 16:42:45.0980 (UTC) FILETIME=[5D69B9C0:01C93E9C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008, David Brownell wrote:
> On Monday 03 November 2008, Frans Pop wrote:
> > Alternative would be to change the following line at 808:
> >                         is_hpet_enabled() ? ", hpet irqs" : "");
> > to:
> >                         is_hpet_enabled() ? "hpet" : "<sensible
> > value>");
>
> The intent was "hpet irqs" vs "native IRQs" (typical PC options)
> vs "no irqs" (e.g. on SPARCs).
>
> I think fixes got trashed when the patch queue got corrupted
> by some queue-jumping ... see the patch in
>
>   http://bugzilla.kernel.org/show_bug.cgi?id=11153
>
> which was broken by a474aaedac99ba86e28ef6c912a7647c482db6dd,
> and has appropriately sane messaging.

AFAICT that patch is still pending, which means that the patch I proposed 
should be good and fix the "regression".

When your original patch is then updated against git head and resubmitted, 
things should still end up as you intended.

Cheers,
FJP
