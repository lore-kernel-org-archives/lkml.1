Return-Path: <linux-kernel-owner+w=401wt.eu-S1764039AbYESW1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764039AbYESW1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYESW1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:27:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:47851 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYESW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OVebewJH6sAx7Y0uzqkuZzhIlMD3jMftxP3sOP4BisjU1IKwcBZsGDmFfOXwBT08ck29o1dw+65vjaHcNEbk/60MrGBZ+QvjT514hlMmzWd7nh9tPrnNj4rW9LXnbLzRADtSUn8/igbQbvQNiHN6PXkw4DOixQTlyuorvC6azsY=
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4831F89F.5060106@zytor.com>
References: <20080519215452.GK17716@cs181133002.pp.htv.fi>
	 <4831F89F.5060106@zytor.com>
Content-Type: text/plain
Date: Mon, 19 May 2008 15:27:28 -0700
Message-Id: <1211236048.5915.94.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 15:01 -0700, H. Peter Anvin wrote:
> Adrian Bunk wrote:
> > Several compilers offer "long long" without claiming to support C99.
> > 
> > Considering how frequent __s64/__u64 are used our userspace headers are 
> > anyway unusable without __s64/__u64 available.
> > 
> > Always offer __s64/__u64 to non-gcc non-C99 compilers - if they provide 
> > "long long" that makes the headers compiling and if they don't they are 
> > anyway screwed.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> This makes sense to me (I did, however, not want to make that change 
> part of the same changeset - one change at a time.)
> 
> The main reason for not just blindly using "long long" has to do with 
> the use of gcc -ansi -pedantic in userspace, which is already taken care 
> of by the use of __extension__ in the __GNUC__ clause.
> 

If it is going to be unconditionally offered, we could get rid of
__BYTEORDER_HAS_U64__ as a next step.  Unless there is something I've
missed.

Harvey

