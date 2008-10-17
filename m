Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYJQOkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYJQOkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYJQOj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:39:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47607 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYJQOjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Bx63SzOyz8bDWv0X44tmsokh+Xq3cge2m7YnTBaz49XxY03uO9aFfmNfx5LrjP85JI
         Zh5R6S7pleUsjSo3vHcRsUWvI6Y2rjlozhb00Wtl+3EnA/IaeCTEzUll7ybJFsrm8q5V
         +7nmSERjRbe7U8jv3EXQ2U0ko+JbzQ15NTG08=
Date: Fri, 17 Oct 2008 18:42:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/31] proc: move rest of /proc/partitions code to
	block/genhd.c
Message-ID: <20081017144256.GB9242@x200.localdomain>
References: <20081017124711.GP22653@x200.localdomain> <20081017134037.GM19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017134037.GM19428@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 03:40:37PM +0200, Jens Axboe wrote:
> On Fri, Oct 17 2008, Alexey Dobriyan wrote:
> > 
> > From de5824cba6d479dc525cb24810582e3606e3d166 Mon Sep 17 00:00:00 2001
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > Date: Sat, 4 Oct 2008 23:53:21 +0400
> > Subject: [PATCH 15/31] proc: move rest of /proc/partitions code to block/genhd.c
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> This and 25/31 look fine to me. How do you plan on merging this?

I think to do it via proc.git.

Looking at -next, nobody will notice, looking at -mm, Rik will notice
because of silly meminfo format string reformat. The rest of meminfo
rejects will be trivially fixed via filename changes.

> I could take the two through the block tree, but seems easier just to merge
> the entire series through eg Andrew.
