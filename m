Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZAFQlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZAFQlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZAFQlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:41:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:20987 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZAFQlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g79RexlCEt2ckLbmEysQ4ibSW7SJdXeU0bcsBtsPK31VW751RLQ1gzAbbZMrY/m2ys
         StgF68K73s3R3mtJQ3ugvEyycXwEIL0M3hlQg1nnOLrPW9T8Gf6fpD7RjgLt21nzlLuP
         Dfk8RdfQx84eCxqLUpIlJCy4oh/5nNWHIFt7Y=
Subject: Re: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, bluebird@gentoo.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
In-Reply-To: <4963311B.6020502@redhat.com>
References: <4943DAD6.7070402@gentoo.org>
	 <20081216.011334.124918024.davem@davemloft.net>
	 <1229564779.6481.26.camel@brick>  <4963311B.6020502@redhat.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 08:41:01 -0800
Message-Id: <1231260061.11902.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 11:23 +0100, Gerd Hoffmann wrote:
> Harvey Harrison wrote:
> > glibc headers define both __LITTLE_ENDIAN and __BIG_ENDIAN
> > which was tripping the check in linux/byteorder.h.  Let's
> > just stay out of userspace's way and use __KERN_{endian}
> 
> Ping.  What is the status of this?
> 
> > Converted the arches in mainline that have already moved to the
> > new header, as the other arches merge the will need simlar
> > fixups.
> 
> In latest git powerpc, s390 and x86 are merged and need this fix too.
> 
> cheers,
>   Gerd

I was waiting for the cris, xtensa and parisc arches to merge as they
have conversion patches in their arch trees.  I'll send the patchset out
today with the proviso it shouldn't be applied until those three have
merged.

Cheers,

Harvey

