Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbXK0TCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbXK0TCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbXK0TCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:02:37 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3394 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbXK0TCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:02:36 -0500
Message-ID: <474C699D.9000501@xs4all.nl>
Date: Tue, 27 Nov 2007 20:01:49 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       folkert van Heusden <folkert@vanheusden.com>
Subject: Re: enable dual rng on VIA C7
References: <47374EA4.1060009@xs4all.nl> <20071125233949.f64b2ecd.akpm@linux-foundation.org> <474AFC2F.1040309@xs4all.nl> <20071126185843.GD15764@redhat.com> <474C40FA.1070501@xs4all.nl> <20071127185053.GA30057@redhat.com>
In-Reply-To: <20071127185053.GA30057@redhat.com>
X-Enigmail-Version: 0.95.5
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
>  > > Something like this perhaps ?
>  > 
>  > Yes, I think that's a big step in the right direction!
>  > 
>  > But I am no expert and cannot really judge how necessary or correct the
>  > implementation is w.r.t. the 'undefined' function bits for CPU's that
>  > lack a certain feature.
> 
> The checks at the end of the patch for the x86_mask/model ensure
> we only enable the 2nd noise source on CPUs documented to have it,
> so we should be safe.
> 
> Andrew, want to throw that in the -mm pile for a while?

Thanks for assuring we are 'safe'.
Sounds OK to me.
Thanks for picking up this tiny improvement.

Any ideas on the power consumption increase question I received w.r.t.
this patch? (or why VIA would have made the 2nd RNG switchable)
