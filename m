Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbXFRVbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbXFRVbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760866AbXFRVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:31:37 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760134AbXFRVbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:31:36 -0400
Message-ID: <4676F9A2.6010007@zytor.com>
Date: Mon, 18 Jun 2007 14:31:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: alan <alan@clueserver.org>
CC: Bodo Eggert <7eggert@gmx.de>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <8wst3-3kh-31@gated-at.bofh.it> <8wsCC-3wf-21@gated-at.bofh.it> <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org>
In-Reply-To: <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alan wrote:
> On Mon, 18 Jun 2007, Bodo Eggert wrote:
> 
>> alan <alan@clueserver.org> wrote:
>>
>>> I just wish that people would learn from the mistakes of others.  The
>>> MacOS is a prime example of why you do not want to use a forked
>>> filesystem, yet some people still seem to think it is a good idea.
>>> (Forked filesystems tend to be fragile and do not play well with
>>> non-forked filesystems.)
>>
>> What's the conceptual difference between forks and extended user
>> attributes?
> 
> Forks tend to contain more than just extended attributes.  They contain
> all sorts of other meta-data including icons, descriptions, author
> information, copyright data, and whatever else can be shoveled into them
> by the author/user.

And that makes them different from extended attributes, how?

Both of these really are nothing but ad hocky syntactic sugar for
directories, sometimes combined with in-filesystem support for small
data items.

	-hpa
