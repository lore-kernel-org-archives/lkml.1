Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbXFRVIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbXFRVIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764311AbXFRVIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:08:07 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:45532 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763894AbXFRVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:08:05 -0400
Date: Mon, 18 Jun 2007 14:08:03 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Bodo Eggert <7eggert@gmx.de>
cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <E1I0OFQ-0001B9-7Z@be1.lrz>
Message-ID: <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org>
References: <8wst3-3kh-31@gated-at.bofh.it> <8wsCC-3wf-21@gated-at.bofh.it>
 <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it>
 <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it>
 <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Bodo Eggert wrote:

> alan <alan@clueserver.org> wrote:
>
>> I just wish that people would learn from the mistakes of others.  The
>> MacOS is a prime example of why you do not want to use a forked
>> filesystem, yet some people still seem to think it is a good idea.
>> (Forked filesystems tend to be fragile and do not play well with
>> non-forked filesystems.)
>
> What's the conceptual difference between forks and extended user attributes?

Forks tend to contain more than just extended attributes.  They contain 
all sorts of other meta-data including icons, descriptions, author 
information, copyright data, and whatever else can be shoveled into them 
by the author/user.

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
