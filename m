Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXLZKi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXLZKi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 05:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXLZKiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 05:38:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:7021 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbXLZKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 05:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YXb+ucQAtOjaJkt6ztLkADPkJx1oCzuX3t48jsAUvxTFTsZC41WJpX4FcA6Q5k7e6i0meHsfchnG7UNAOTmveiq++P/koyzMz+X99zJYnoPwDx+ekeWpTzELcFDTEDifIlFOYnWnbaeUAzBbQ5kYoAGbtaOF7Wl3Z+wyYqH699g=
Message-ID: <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com>
Date: Wed, 26 Dec 2007 13:38:16 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86] is checkpatch.pl broken
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <477196DC.9000704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071225170737.GA3887@cvg.org> <477196DC.9000704@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 26, 2007 2:48 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Cyrill Gorcunov wrote:
> > Hi list,
> >
> > by doing cleanup of arch/x86/boot/*.[ch] i found that
> > checkpatch does ignore obvious things. For example,
> > run it over edd.c showed only one warning:
> >
> > BTW, is there someone who is already involved in a such
> > cleanup to eliminate double effort?
> >
>
> BTW, it's more than a wee bit rude of you to Cc: a bunch of people but
> not the listed maintainer of the piece of code you're claiming to be
> cleaning up.
>
>         -hpa
>
It's a quite true, sorry for this and thanks for the note. And Peter,
the line I marked
is not to be splitted even having additional spaces over  math operators. Look

orig:
mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
new (could be):
mbr_base = (buf_base + sector_size - 1) & ~(sector_size - 1);

Is a new version that bad?
Anyway, as only I've something really done, i'll send it to the list
so you/mainteiner could choose which version is to be in kernel ;)
