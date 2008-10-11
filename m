Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYJKGrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYJKGrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbYJKGi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41482 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbYJKGh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:28 -0400
Date: Sat, 11 Oct 2008 08:36:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, torvalds@osdl.org
Subject: Re: libata: set queue SSD flag for SSD devices
Message-ID: <20081011063650.GL19428@kernel.dk>
References: <200810101904.m9AJ42Gq018897@hera.kernel.org> <20081010202515.446857cc@lxorguk.ukuu.org.uk> <20081010200528.GJ19428@kernel.dk> <20081010175508.3d1ed2a4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010175508.3d1ed2a4@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, Arjan van de Ven wrote:
> On Fri, 10 Oct 2008 22:05:28 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > In this specific patch, it'll do no harm at least since I very much
> > doubt we'll see a false positive. And even if, the consequences wont
> > be dire. But it does want the version check, of course.
> > 
> 
> also, is "is an ssd" the right question or is "doesn't have seek
> latency" the right one?
> (difference is.. well EMC boxes with lots of ram etc)

The block layer uses the 'non rotational' nomenclature for this, but
that's not perfect either. And neither is 'no seek', a single
"parameter" is not enough to describe the device. But it's good enough I
think, it'll be expanded later with a (bit) fuller profile.

-- 
Jens Axboe

