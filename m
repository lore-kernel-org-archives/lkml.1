Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbXD0UF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbXD0UF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXD0UF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:05:57 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:16423 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbXD0UFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=XIqNfDgZkRQMsbH0JVY+BMrsLxX+89kG+CSF2ArmBOMAbdKL4uT8ixb0ZR++uM/vId2yhtUAVLsSier+qRnEyUSRCTKv6nW1ElxiomnViBiO5YhI397gTdIpxB85nCXO8RDEmdeEOT5ZwLVNkoFWzK/R29zKEGXOMigH+JGlTgo=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Andreas Dilger'" <adilger@clusterfs.com>
Cc: "'Marat Buharov'" <marat.buharov@gmail.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Mike Galbraith'" <efault@gmx.de>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Jens Axboe'" <jens.axboe@oracle.com>, <linux-ext4@vger.kernel.org>,
       "'Alex Tomas'" <alex@clusterfs.com>
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Subject: RE: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 13:05:42 -0700
Message-ID: <03a701c78907$70470f30$50d52d90$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AceJBdl8CnxA0fVxSNS9RwvhlCExJgAAW6Pg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The idea has not died and some NAS/file server vendors have already been
doing this for some time. (I am not sure but is WAFS the same thing?)

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Linus Torvalds
> Sent: Friday, April 27, 2007 12:51 PM
> To: Andreas Dilger
> Cc: Marat Buharov; Andrew Morton; Mike Galbraith; LKML; Jens Axboe;
> linux-ext4@vger.kernel.org; Alex Tomas
> Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose
> when FS is under heavy write load (massive starvation)
> 
> 
> 
> On Fri, 27 Apr 2007, Andreas Dilger wrote:
> >
> > It's true that this is a "feature" of ext3 with data=ordered (the
> default),
> > but I suspect the same thing is now true in reiserfs too.
> 
> Oh, well.. Journalling sucks.
> 
> I was actually _really_ hoping that somebody would come along and tell
> everybody that this whole journal-logging is stupid, and that it's just
> better to not ever re-write blocks on disk, but instead write to new
> blocks with version numbers (and not re-use old blocks until new
> versions
> are stable on disk).
> 
> There was even somebody who did something like that for a PhD thesis, I
> forget the details (and it apparently died when the thesis was
> presumably
> accepted ;).
> 
> 			Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

