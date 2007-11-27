Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXK0QJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXK0QJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbXK0QJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:09:09 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2913 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbXK0QJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:09:08 -0500
Message-ID: <474C40FA.1070501@xs4all.nl>
Date: Tue, 27 Nov 2007 17:08:26 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Udo van den Heuvel <udovdh@xs4all.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>,
       folkert van Heusden <folkert@vanheusden.com>
Subject: Re: enable dual rng on VIA C7
References: <47374EA4.1060009@xs4all.nl> <20071125233949.f64b2ecd.akpm@linux-foundation.org> <474AFC2F.1040309@xs4all.nl> <20071126185843.GD15764@redhat.com>
In-Reply-To: <20071126185843.GD15764@redhat.com>
X-Enigmail-Version: 0.95.5
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Mon, Nov 26, 2007 at 06:02:39PM +0100, Udo van den Heuvel wrote:
> 
>  > I did not know we are already that far ;-)
>  > I mean: can this patch be aplied without hurting C3/C7 CPU's with just
>  > one RNG? Maybe an expert needs to test/answer?
>  > Maybe some logic needs to be applied around the extra bit?
>  
>>From the padlock spec..
> 
> "SRC Bits[9:8] Noise source select (I): These bits control the two noise
>  sources on the processor that input bits to the accumulation buffers.
>  On Nehemiah processors prior to stepping 8, these bits are reserved
>  and undefined. The default RESET state is both bits = 0." 
> 
> Something like this perhaps ?

Yes, I think that's a big step in the right direction!

But I am no expert and cannot really judge how necessary or correct the
implementation is w.r.t. the 'undefined' function bits for CPU's that
lack a certain feature.
