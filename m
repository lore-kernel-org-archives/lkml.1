Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYHCOi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYHCOi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYHCOit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:38:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:21714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbYHCOis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=GU77gu3e78ly5VySLUGYCNv+6rnzsqvJwXaG8jZZAoERhBA0OOJa4fcT9GvanUNVtM
         o0WbG3akJLpykT38vneknmnfH9c+cQ7hJa0ON1nYTkIkp7eAFQlnN5Cg9W2yUDeigPpV
         yoyr4Awt9l69mpxXydRP9WGLmmR4a8HemNY84=
Date: Sun, 3 Aug 2008 16:38:37 +0200
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: petkovbb@googlemail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Message-ID: <20080803143837.GA26672@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	petkovbb@googlemail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, alan@redhat.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200808021902.12191.bzolnier@gmail.com> <20080802183253.GA2239@gollum.tnic> <200808022046.16990.bzolnier@gmail.com> <20080803073756.GA8762@gollum.tnic> <20080803125907.67676948@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080803125907.67676948@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 12:59:07PM +0100, Alan Cox wrote:
> On Sun, 3 Aug 2008 09:37:56 +0200
> Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > Ok, here's a definitely better solution:
> 
> Please don't stuff large important pieces of code in header files where
> they will be overlooked

What do you mean by "overlooked"? If you're looking for the function defintion,
any sensible code indexing tool will point you to the right place.

And linux/ata.h already contains several c one liners/helpers. What is the
difference between the two new functions and the ones already present there?
Although the solution i propose is not adhering to some header/c file
conventions, it is still the best one considering the other possibilities:

a) code duplication: dumb idea, bloated kernel for no reason

b) evil Kconfig SELECT pulling in core libata just so that ide might be calling
a function or two.

[.. ]


-- 
Regards/Gruss,
    Boris.
