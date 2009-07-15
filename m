Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZGOSn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZGOSn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZGOSn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:43:57 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:38032 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbZGOSn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:43:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=azr7vOo8YoDXxQf6ei6gyMXar52ftS3BBqmJxAvDXHj6jIfE9WDQDBzpqw+282tfKz
         /SR/HCtF/qSoy21Gvdi3nK5OMGhCIAS94fCBUZLM35A52tG7aSpaxfzb7itrT50myJlh
         wsB4bBH7Y2ouvJvAykzIdlKG9UelBnKwODuq4=
Date: Wed, 15 Jul 2009 20:43:50 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ide-tape: misc stuff
Message-ID: <20090715184350.GA13708@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	David Miller <davem@davemloft.net>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1247671100-8173-1-git-send-email-petkovbb@gmail.com>
 <20090715.111606.193724419.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090715.111606.193724419.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:16:06AM -0700, David Miller wrote:
> From: Borislav Petkov <petkovbb@googlemail.com>
> Date: Wed, 15 Jul 2009 17:18:16 +0200
> 
> > here is some ide-tape stuff.
> > 
> > * 0001: somehow fell through the cracks, DEBUG build fix
> 
> This is OK.
> 
> > * 0002: mostly code unification
> 
> I'm not applying this.  IDE is in deep maintainence mode and
> we really need to avoid changes that don't fix real bugs and
> have only marginal benefit, like this change.
> 
> > * 0003: this one converts ide-tape to the debugging scheme we use with ide-cd
> >   and ide-floppy. It adds some debug calls at important places and has proven
> >   very helpful when working on bug reports with users. No functional change.
> 
> I'm not applying this for the same reason as patch #2.

Well, the downside to that is whenever there's a bug report and I want
the user to do a debug build and send me the output, I'll have to rehash
that debug patch and send it to her/him, maybe teach her/him how to
patch a kernel, build it and catch the output and send it my way before
we do some real work. Having the change upstream makes it _a_ _lot_
_more_ easier to do that and this is experience talking, we had several
scenarious like that already.

So, applying those would be of great help to me without the danger of
introducing any regressions but I guess, it's your call. Still, I'd
really appreciate it if you reconsidered.

Thanks.

> > * 0004: real bugfix
>
> Ok, did you test this?

Yes.

-- 
Regards/Gruss,
    Boris.
