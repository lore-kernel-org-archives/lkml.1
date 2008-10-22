Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYJVQfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYJVQfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbYJVQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:35:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:40354 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbYJVQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eL6Gneh4Wr+UhNIgzerUDuUJNpxt9p34nM25iZZ7b+co0no2Evr6X5lfJbKBfuVqTJ
         nv2Ds2fQ5UeobZAsQmOfu/as6Pmp/wCTKsA0WcM3BUdlRrYloRBiDCilKJL4p5v8mIGJ
         1lzLaEdcpfJYDNHl8d4aaHJ5exgrkv1m9JxkM=
Date: Wed, 22 Oct 2008 20:35:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022163530.GH9639@localhost>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810220926130.7633@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Wed, Oct 22, 2008 at 09:28:14AM -0700]
> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>
>> Please check -- wouldn't it be better to use such a macro?
>
> Looks good. But could you rename OO_MAX to something different? There is  
> already s->max which may cause confusion because s->max is the maximum  
> number of objects in a slab. OO_MAX is the maximum mask?
>

I supposed it would mean maximum object number inside page (ie quantity) which
is happen to be the same value as OO_MASK. Maybe OO_MAX_OBJ?

		- Cyrill -
