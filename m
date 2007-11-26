Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbXKZRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbXKZRDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXKZRDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:03:07 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1481 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXKZRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:03:05 -0500
Message-ID: <474AFC2F.1040309@xs4all.nl>
Date: Mon, 26 Nov 2007 18:02:39 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       folkert van Heusden <folkert@vanheusden.com>
Subject: Re: enable dual rng on VIA C7
References: <47374EA4.1060009@xs4all.nl> <20071125233949.f64b2ecd.akpm@linux-foundation.org>
In-Reply-To: <20071125233949.f64b2ecd.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 11 Nov 2007 19:49:08 +0100 Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> 
>> Any reason why the second rng on the VIA C7 CPU is not enabled?
(...)
> Does the patch work?

Yes, at least:

dd if=/dev/hwrng of=/dev/null bs=1024 count=1024
shows a higher speed than without the patch.

> It's missing a signed-off-by:, btw

I did not know we are already that far ;-)
I mean: can this patch be aplied without hurting C3/C7 CPU's with just
one RNG? Maybe an expert needs to test/answer?
Maybe some logic needs to be applied around the extra bit?

Kind regards,
Udo
