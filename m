Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbXLVI67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbXLVI67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXLVI6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:58:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:20379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbXLVI6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:58:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MsLM0Pf+8CL7cBE2pfVdbh1XeyAJkznpmuQ5YL5ytQcT3wuR/PyEFg6qiyUZbapzyjtsQ4NeVyPtjSEDzboZD27U/S5LbKG/zxPaEe1iE9qs5nz+LNdBF4KtqEtfPkPgWRApNfG2HO4GCClOBmOOfhnk3E33l5BGoRW2qJVPgyc=
Date: Sat, 22 Dec 2007 10:00:28 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       jack@suse.cz
Subject: Re: [PATCH 1/5] udf: remove wrong prototype of udf_readdir
Message-ID: <20071222090021.GA7872@joi>
References: <20071221155453.GA8575@joi> <20071221162117.faa3d16d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071221162117.faa3d16d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 04:21:17PM -0800, Andrew Morton wrote:
> On Fri, 21 Dec 2007 16:55:03 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
>
> > sparse generated:
> > fs/udf/dir.c:78:5: warning: symbol 'udf_readdir' was not declared. Should it be static?
> > there are 2 different prototypes of udf_readdir - remove them and move
> > code around to make it still compile
>
> Drat.  I just applied six udf patches from you and now we have a new patch
> series of only five with no indication what changed.
>
> I guess I really do need to apply my backlog in reverse time order.
I'm sorry for that. I added acked-by as Jan Kara suggested [1] and added better
description for 3rd patch. 6th patch was dropped [2] because it should be cleaned
up differently.

Marcin

[1] http://lkml.org/lkml/2007/12/20/151
[2] http://lkml.org/lkml/2007/12/17/201
