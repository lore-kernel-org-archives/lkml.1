Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYDOGex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYDOGex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYDOGeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:34:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:16779 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYDOGep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AFVfatj0AaX2yThks4LdTHlCuvIEemdv7U/1DNIHdJI8RTGh0F3lwLzbnxgqvuIZVtDPevmC7f8lVki2J/8uG3YpLyPiSCK/6VH0HEV1397X7l5wuloMq7doUQuvl7xXt3NgV6dI30XzOkYjrqKgrq/1KCyyLpRosSCav+xqjUE=
Message-ID: <cfd18e0f0804142334w23a0f492we6b0a47ebee055f7@mail.gmail.com>
Date: Tue, 15 Apr 2008 08:34:42 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch] F_GETPATH implementation (rev 2)
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arnd Bergmann" <arnd@arndb.de>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <alpine.LFD.1.00.0804141931070.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804141700010.6238@alien.or.mcafeemobile.com>
	 <alpine.LFD.1.00.0804141931070.2879@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 4:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 14 Apr 2008, Davide Libenzi wrote:
> >
> > This is a small patch to support BSD's F_GETPATH on Linux.
> > IMO the simplicity of the patch and the portability advantages makes it
> > worth it. I'll leave to others to further comments it.
>
> So, I'd like to know who (if anybody) really uses F_GETPATH.

Davide described this as "BSD's F_GETPATH".  It's worth clarifying
that more accurately this is "MacOS's F_GETPATH".  I can't find any
trace of F_GETPATH on Net/Open/FreeBSD, Solaris doesn't seem to have
it either, and none of the other systems I checked has it either.
