Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbYAJQIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbYAJQIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYAJQIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:08:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:56728 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbYAJQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:08:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pvRG5g3lLyjsgbsULwyzoSNUrBuipF2rao2HK+tExbd5La36h2A1D2mzvY278yXoI+lGOjMoSj5EEtWXWmBlRHhPGa3YbCh+CdoEiDTZXlIo/vUKoHnRsJMtzFxi3lzs9ZbcG2J8uHkUvpunaa7SnAzxVQU9eTDoj9tbK6zLSrM=
Message-ID: <170fa0d20801100808x7330589fj8f6884f56a194e76@mail.gmail.com>
Date: Thu, 10 Jan 2008 11:08:18 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080110104155.34b5cede@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108205939.323955454@redhat.com>
	 <170fa0d20801092039w22584e2fw6821e70157f55cae@mail.gmail.com>
	 <20080110104155.34b5cede@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 10:41 AM, Rik van Riel <riel@redhat.com> wrote:
>
> On Wed, 9 Jan 2008 23:39:02 -0500
> "Mike Snitzer" <snitzer@gmail.com> wrote:
>
> > How much trouble am I asking for if I were to try to get your patchset
> > to fly on a fairly recent "stable" kernel (e.g. 2.6.22.15)?  If
> > workable, is such an effort before it's time relative to your TODO?
>
> Quite a bit :)
>
> The -mm kernel has the memory controller code, which means the
> mm/ directory is fairly different.  My patch set sits on top
> of that.
>
> Chances are that once the -mm kernel goes upstream (in 2.6.25-rc1),
> I can start building on top of that.
>
> OTOH, maybe I could get my patch series onto a recent 2.6.23.X with
> minimal chainsaw effort.

That would be great!  I can't speak for others but -mm poses a problem
for testing your patchset because it is so bleeding.  Let me know if
you take the plunge on a 2.6.23.x backport; I'd really appreciate it.

Is anyone else interested in consuming a 2.6.23.x backport of Rik's
patchset?  If so please speak up.

> > I see that you have an old port to a FC7-based 2.6.21 here:
> > http://people.redhat.com/riel/vmsplit/
> >
> > Also, do you have a public git repo that you regularly publish to for
> > this patchset?  If not a git repo do you put the raw patchset on some
> > http/ftp server?
>
> Up to now I have only emailed out the patches. Since there is demand
> for them to be downloadable from somewhere, I'll also start putting
> them on http://people.redhat.com/riel/

Great, thanks.

Mike
