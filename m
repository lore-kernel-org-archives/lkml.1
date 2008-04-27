Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbYD0Ukb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbYD0Ukb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYD0UkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:40:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:38501 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYD0UkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UHNzTRyN6M9SEUzA1FVlicGJFb6TCpfPS0wLkAggMqcJ9+5nXSTPXPS5AUXUKaX7lmbUcJ6u4AXspQgqX538LFKM4L0n/48zbN0oEmwzOeUt8RRv/EeCaYXE3vlRCAImaXczcU6s947KAUystSMDPAUceYP0o7bH8wxBTUCdzNo=
Message-ID: <9a8748490804271340m383fa01dk3ea3bd820c33a334@mail.gmail.com>
Date: Sun, 27 Apr 2008 22:40:17 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][Resend] Let SYSVIPC default to 'y'
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, trivial@kernel.org
In-Reply-To: <20080427211740.76bea46d@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0804272208250.2352@dragon.funnycrock.com>
	 <20080427211740.76bea46d@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/27 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Sun, 27 Apr 2008 22:11:03 +0200 (CEST)
>  Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
>  > From: Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>  >
>  > [This patch was previously submitted on  24 April 2008 01:01]
>
>  And people responded pointed out that entire distributions were running
>  with SYS5 IPC off and no ill effects so why is it stil being resubmitted ?
>

Well, because in my experience there are many programs out there that
do not run fine with this off, and I believe that our defaults should
try to be a kernel that works well for as much software as possible
out there.
The overhead of including this is fairly low. Thare are apps out there
that require it. It's just a default for the kernel.org kernel,
distros can still set whatever they please.
But OK, I'll leave it at this and not resubmit it again if it doesn't
get merged, I don't feel that strongly about it.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
