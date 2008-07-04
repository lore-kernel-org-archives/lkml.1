Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYGDQiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYGDQiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYGDQiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:38:02 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:32544 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYGDQiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R5w6uBEjOktdAmJ5zlB5TnblgFwVo68lS/MlHulXdSMKP6qtvMoK1xkJa+rG+laZYB
         5NECHGT5xLR0t9eSPz1IKw8yJOnmfFcyhr5mrg8J6u3rL1nohLBQ1ykCpXWAnNVxOcfK
         G2UwSaW1fEJADgpjqLJ2pX9gLiA8IuDtLo0eg=
Subject: Re: [PATCH 4/5] byteorder: fix direct byteswap includes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <27042.1215185863@redhat.com>
References: <1215144734.16647.70.camel@brick>  <27042.1215185863@redhat.com>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 09:37:53 -0700
Message-Id: <1215189473.16647.80.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 16:37 +0100, David Howells wrote:
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > +#include <asm/byteorder.h>
> 
> Please use <linux/byteorder.h> rather than <asm/byteorder.h> when including
> stuff from .c files outside the include and arch directories.

asm/byteorder.h is the file included everywhere else, and before my
patches, linux/byteorder.h didn't even exist.  Thus, when preparing my
patches I made sure that including asm/byteorder.h continued to be the
way to get this functionality.

I could add another patch  on top that makes linux/byteorder the one we
want included and search/replace the existing asm includes, but I thought
that was a bit too big to do in one go.

If people think this is the way to go, I'll prepare a patch to change the
includes.

> And whilst you're at it, Documentation/byteorder.txt is yours for the
> creation:-)

Already working on an update to unaligned_access.txt, I'll get to
byteorder next.

Harvey

