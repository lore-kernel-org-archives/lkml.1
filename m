Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYAENYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYAENYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 08:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYAENYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 08:24:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:40438 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbYAENYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 08:24:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ldbsBWw8RxQCG6TGuuByJXzgKZ47AtLGPFklvLNCUkqxgwcZJh/l+lZPj4+wQM5ZzLmU9qfvwYjVxZH+cq339xxvD5P1JHkYYDSa3QLB6V3gemnS522WjEEUyyS5yR3m+lc5AczXXF3CJe0vOepFnDn3RTPlTs/iKo+LlgsilMY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bbpetkov@yahoo.de
Subject: Re: [RESEND PATCH 02/10] ide-floppy: move ide-floppy struct and macro defs into its own header. While at it
Date: Sat, 5 Jan 2008 14:15:16 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <200801042349.09964.bzolnier@gmail.com> <20080105124501.GA5704@gollum.tnic>
In-Reply-To: <20080105124501.GA5704@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801051415.16775.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 05 January 2008, Borislav Petkov wrote:
> On Fri, Jan 04, 2008 at 11:49:09PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> Hi Bart,
> 
> > Hmm, contrary to ide-cd.c case there doesn't seem to be a need currently for
> > moving code out of ide-floppy.c (and this patch series doesn't change that).
> ?, you mean this patch series _does_ change that, meaning it moves the struct

I mean that even with this patch series applied there is no need to for header
file since ide-floppy will still be the only user of it.

> defs into a header file. Do i get this correctly that we don't need the header
> file and the struct defs should remain in the .c file?

Yes.

> > Besides it would be better to just remove some structs like it has been done
> > with i.e. struct atapi_capabilities_page in ide-cd.c case [1] because:
> 
> [...]
> 
> > typedefs are evil (exceptions are rare) and should die :)
> > 
> 
> i'm redoing them right now against ide-2.6.git and will post when ready. By the

ide-2.6.git is for syncing with Linus, the development tree is kept in quilt
tree and is merged by Andrew to -mm.  Please get the quilt patch series from:

http://www.kernel.org/pub/linux/kernel/people/bart/pata-2.6/

or use the latest 2.6.24-rc6-mm1 kernel (should have most of IDE patches).

> way, i have done some more cleanups in the meantime. Should i include them into
> this series or send them later?

Include! :)

Thanks,
Bart

PS I still have to comment on patches #5/6/8/9.
