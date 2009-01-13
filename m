Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZAMTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZAMTF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZAMTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:05:12 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:44009 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZAMTFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:05:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jpfZxXzuvJi+UX+R75TsybFAUP+XrLmhyY5BIx/YtnlIZc1sdeFT5myBvz91ALjC4u
         7faO2+r3JjkdIOLhkmseKLm3mTTolMfSTcIgjQpyTxmUhx9V7n/9STaUdTe0u3fLuvLh
         Hm00SDPCDRzuqCEglY6Y3El7WvuQ7W9DitotU=
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
 userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
In-Reply-To: <496CE234.2070900@zytor.com>
References: <20090113183456.GA14470@localhost>
	 <1231871832.16221.1.camel@brick>  <496CE234.2070900@zytor.com>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 11:05:07 -0800
Message-Id: <1231873507.16221.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 10:49 -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > On Tue, 2009-01-13 at 21:34 +0300, Cyrill Gorcunov wrote:
> >> Impact: cleanup
> > 
> >> 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
> >>    could use it.
> > 
> > Doesn't this need to be (at least) _COMMAND_LINE_SIZE to avoid
> > polluting the namespace, not sure it can be changed though as the
> > horse is already out of the barn.
> 
> No, this is not one of those cases, but it's worth explaining why.
> 
> You can introduce symbols into the general namespace if *and only if*
> they are in a header file that is invoked directly by the user.  In
> other words, such a header file is unusable by libc, but setup.h doesn't
> contain anything needed by libc in the first place.
> 

Thanks for the explanation, while I was aware of that, I hadn't actually
looked if libc pulled this in...thinking a bit more it should have been
obvious libc wouldn't be interested in this header.

Thanks.

Harvey


