Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbYE3G0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbYE3G0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYE3G0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:26:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbYE3G0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YH85DjgWlReBitosZ0deg6X6xAf5JmJAbFbJNKEhGiIOUMTll8XtctP+pLirJ9FdX/dYKLjuTkeqBGw9L72Sruj0Trxm75C8N+cV0yJhVdIL4ssgmDId5Hubsfalr4fSXWOszUG9p8Pf3seXV2wxzzKzTjLrYFo/54cxCBX6QYQ=
Message-ID: <21d7e9970805292326m1a238aa1id8b6733351ba15d3@mail.gmail.com>
Date: Fri, 30 May 2008 16:26:38 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: in-kernel DRM tree move around....
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1212058935.26088.11.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
	 <1212058935.26088.11.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 9:02 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Thu, 2008-05-29 at 10:46 +1000, Dave Airlie wrote:
>> Hi,
>>
>> So I've been growing more annoyed with the current layout of the drm
>> tree in the kernel,
>>
>> a) it lives under char.
>> b) everything in one directory.
>> c) header files in one directory.
>> d) no header files exposed to userspace.
>>
>> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
>>
>> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
>> well later). It also creates per-driver subdirs.
>
> Looks sane from the header export POV. Passes headers_check and doesn't
> add any more instances of CONFIG_xxx visible to userspace (I'm coming
> after those, soon).
>

So assuming I fixed up the kbuild issues, any ideas on when it would
be a good plan to upstream this sorta major movement.

Not many DRM patches don't come via me, and I can fix up the ones that
do before I merge them.

Linus? any ideas on when you would prefer to take a tree like this?
start of rc1?

Dave.
