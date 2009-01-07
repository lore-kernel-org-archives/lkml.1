Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZAGAQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZAGAQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZAGAQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:16:28 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:37244 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZAGAQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PML7K5BWmJjaEMwFjdGrf/EaAvo8I1nwbGpwRk7GEeqCmL0H18uQrOvqhJxjrZptBt
         pjDnNnSi1cfnuu+hAZW1Q1sizeFzcB7dSN0OJytytV2PlNpqfF8HxM0egeLynu88cIg0
         /HVgymRWomSj2Pw7b4n3US9Af0mxj/MXh7ZQc=
Subject: Re: 2.6.29 -mm merge plans
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Diego E. 'Flameeyes'" =?ISO-8859-1?Q?Petten=F2?= 
	<flameeyes@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Warren Turkal <wt@penguintechs.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1231286954.5158.18.camel@localhost>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <20090106225744.GA10553@infradead.org>
	 <20090106151747.c640dfd4.akpm@linux-foundation.org>
	 <20090106231958.GA30271@infradead.org> <1231284433.5158.2.camel@localhost>
	 <20090106233153.GA16469@infradead.org> <1231286954.5158.18.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jan 2009 16:16:24 -0800
Message-Id: <1231287384.1529.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 01:09 +0100, Diego E. 'Flameeyes' Pettenò wrote:
> On Tue, 2009-01-06 at 15:49 -0800, Harvey Harrison wrote:
> > One other nit, byteswap the constant so it can be done at compile-time:
> > 
> I copied over the code from dir.c, so I've propagated the change to
> that, and also to super.c where a similar case was present, I'm
> attaching it at 0002 (but maybe it should go in before the NFS export
> support?).
> 
> I've not checked if there are other cases where this can be optimised
> though, maybe I should.
> 

Depending on how often they are used, perhaps just define those constants
directly as be values and get the cpu_to_beXX out of the codepaths.  If
they're also used on cpu-endian values, this isn't so great...but I haven't
actually looked.

Cheers,

Harvey

> If you all are in mood of HFS+ patches review, I might try to run the
> code through a couple of my tools, I had in my TODO list to try them on
> kernel code for a while ;)
> 

Feel free to send me whatever your most recent patchset  is and I'll have a
look at it. (at least a good sparse-checkup)

Cheers,

Harvey

