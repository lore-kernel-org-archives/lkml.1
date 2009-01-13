Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZAMSwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZAMSwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZAMSwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:52:42 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:60538 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZAMSwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:52:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w5GjvzAk6rbYE0FJ45iQ/sVSNd7fusGJ5oDTBpZzHSnyRXN+mRKgTIar358UXu9Cgp
         UzvJnkFn6TBm/iK5Xw7scNmSlx8YHT2s/ecJMWYdNaIpOv1f0uF94o4v5J+9XB9hk62E
         3n4VfRjgImK1qSY+mh2B+PBTvgCpi+BQei5XE=
Date: Tue, 13 Jan 2009 21:52:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
	userspace
Message-ID: <20090113185239.GC14470@localhost>
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick> <496CE234.2070900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496CE234.2070900@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Tue, Jan 13, 2009 at 10:49:24AM -0800]
| Harvey Harrison wrote:
| > On Tue, 2009-01-13 at 21:34 +0300, Cyrill Gorcunov wrote:
| >> Impact: cleanup
| > 
| >> 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
| >>    could use it.
| > 
| > Doesn't this need to be (at least) _COMMAND_LINE_SIZE to avoid
| > polluting the namespace, not sure it can be changed though as the
| > horse is already out of the barn.
| 
| No, this is not one of those cases, but it's worth explaining why.
| 
| You can introduce symbols into the general namespace if *and only if*
| they are in a header file that is invoked directly by the user.  In
| other words, such a header file is unusable by libc, but setup.h doesn't
| contain anything needed by libc in the first place.
| 
| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

So we could just fence it by __KERNEL__?

		- Cyrill -
