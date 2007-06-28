Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbXF1DmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbXF1DmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbXF1Dlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:41:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48887 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914AbXF1Dly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SCywa8jIVmNm/sWPwgWVfcwyO/Oj7QMHBwwtYab9czmqORrr65EdCTPyNJvgVMBJCvccTW0NmRkZ+EokmmGBo8L5ic5IwvfY+UV3ihAG8P/ZsRKm1O2+slchXA8x7/g+vj3l1Cr1HLkgtpJxS3d5u7L36tjV4o95aMsh8kxvH08=
Message-ID: <75b66ecd0706272041r2e33241djf2280d1749e8c809@mail.gmail.com>
Date: Wed, 27 Jun 2007 23:41:54 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Andreas Hartmetz" <ahartmetz@gmail.com>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706262239.05070.ahartmetz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706262239.05070.ahartmetz@gmail.com>
X-Google-Sender-Auth: c1bb0accc9f6a26a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Andreas Hartmetz <ahartmetz@gmail.com> wrote:
> Why not put the whole sound system in userland? It has been done before. Sound
> is just not performance critical at all and it's almost never mission
> critical.

There are dozens of companies selling Linux powered professional audio
gear, multiple pro audio centric distros, and hundreds of serious free
software audio apps.  I suspect these developers and their users would
disagree.

I agree with you about userland drivers but at minimum this would
require merging the -rt kernel patches, otherwise the latency/jitter
will be too high to do anything but toy desktop sounds, then you need
a mergeable mechanism for doing DMA and interrupt handling in
userspace.  It has been attempted before but never evolved to the
point where you could drive a complex device like the emu10k1.

Lee
