Return-Path: <linux-kernel-owner+w=401wt.eu-S934696AbXGRQgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696AbXGRQgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932777AbXGRQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:36:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:24440 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549AbXGRQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:36:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VirTOQ3ys0Sbz7dv5LbQ950ixbC1YCiWu4lc+o5XTwe7ZE8cN/C1AkfHYFOjxU9ohSH+iHBY4DeRni2W11J1Z2j9nmlMMbukldOQtPx33g36tyDQGzqtE/MLDflSCORcxmoFYpBzn9LMGAaO7eXo9MO0qXb6dqsN4HLKSPbA8lo=
Message-ID: <a781481a0707180936q14076056ue09270d007fb212b@mail.gmail.com>
Date: Wed, 18 Jul 2007 22:06:19 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
In-Reply-To: <469E401D.2020506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
	 <469E2A68.6010307@gmail.com>
	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
	 <469E352A.90909@gmail.com>
	 <a781481a0707180906w38b151faqd7077ee3da21aff3@mail.gmail.com>
	 <469E401D.2020506@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> Satyam Sharma wrote:
> > Readability, fewer LOC, 308 lesser bytes in kernel image and
> > faster for the common case -- not good enough for you?! Oh, well.
>
> Sorry, not agreed on readability.  The rest doesn't really matter too
> much and please stop making big deal out of this kind of stuff.  Things
> like that do matter but not that much.  Mostly it's matter of getting
> used to and there are many alternatives.  Some people like things one
> way other people like another.  My taste might not be the best around
> here but I don't think it's that awful either.  You may find my taste
> disgusting but we all have to deal with such issue, don't we?

Whoops, I didn't mean to get confrontational, and certainly didn't
make any remarks on your taste/etc personally. Just felt that the
present code looked obfuscated, and submitted a cleanup -- the
other things just turned out to be happy side-effects.

Satyam
