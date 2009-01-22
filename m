Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZAVWZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZAVWZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbZAVWYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:24:48 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:56647 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748AbZAVWYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:24:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xkgRtkRsfwDg+7t38Ob4XI8JuJ2dIgoUZv+N9YyUKL50nPuTaQxUnAJuyR5ese0rKK
         oTijjXOocM0a//jsxzLhE4VQac72XGdfirPrJRgGh8qEPiYIldiQilqF5AVThNSzZ2k2
         uAT1P+udhs3dd3i9Yg/VfZ9JnOZUIV/gW9pDI=
MIME-Version: 1.0
In-Reply-To: <20090122221641.GA31487@elte.hu>
References: <20090109193738.GA9827@linode.davidb.org>
	 <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org>
	 <20090110101235.7ca24c44.akpm@linux-foundation.org>
	 <20090110221528.GA31774@elte.hu>
	 <Pine.LNX.4.64.0901111022590.30201@anakin>
	 <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de>
	 <20090122215041.GA29369@redhat.com> <20090122221641.GA31487@elte.hu>
Date: Fri, 23 Jan 2009 00:24:41 +0200
X-Google-Sender-Auth: 6c2e90a942ee20b1
Message-ID: <84144f020901221424l7905d88ajc5c5438fe491da6c@mail.gmail.com>
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Jan 23, 2009 at 12:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
> "real review" only becomes easy if the code _is reviewable to begin with_:
> if it is written in standard coding patterns where we almost
> sub-consciously recognize bad constructs and bad practices.
>
> I've seen it time and again that if the code is cleaned up visually, real
> review and real improvements follow eventually. It's a gradual process and
> you just cannot do "real review" efficiently without what you call the
> "checkpatch crap".

Agreed. When I looked at the pile of crap in drivers/staging/winbond
at first, it was more or less impossible to even say what the hell the
driver was doing. That was because (a) there were tons of obfuscating
wrappers carried over from Windows driver APIs and (b) there's so much
dead code it's not even funny!

So yeah, doing a "real review" on that monster before we get the
basics right would probably be a complete waste of time.

                                 Pekka
