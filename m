Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXFOWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXFOWvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbXFOWvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:51:10 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:51452 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbXFOWvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:51:08 -0400
Date: Fri, 15 Jun 2007 15:51:07 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <467314E2.9010306@zytor.com>
Message-ID: <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, H. Peter Anvin wrote:

> Jack Stone wrote:
>> I hope I got the CC list right. Apologies to anyone in didn't include
>> and anyone I shouldn't have included.
>>
>> The basic idea is to include an idea from VMS that seems to be quite
>> useful: version numbers for files.
>>
>> The idea is that whenever you modify a file the system saves it to na
>> new copy leaving the old file intact. This could be a great advantage
>> from many view points:
>> 	1) it would be much easier to do package management as the old
>> 		version would be automatically saved for a package
>> 		management system to deal with.
>>
>> 	2) backups would also be easier as all versions of a file
>> 		are automatically saved so it could be potentially very
>> 		useful for a company or the like.
>>
>
> This is one of those things that seems like a good idea, but frequently
> ends up short.  Part of the problem is that "whenever you modify a file"
> is ill-defined, or rather, if you were to take the literal meaning of it
> you'd end up with an unmanageable number of revisions.

And no drive space.

> Furthermore, it turns out that often relationships between files are
> more important.

And there are files that are not important at all.

Would you save every temp file?  To be meaningful you would need to know 
the process they were tied to in many cases.

> Thus, in the end it turns out that this stuff is better handled by
> explicit version-control systems (which require explicit operations to
> manage revisions) and atomic snapshots (for backup.)

ZFS is the cool new thing in that space.  Too bad the license makes it 
hard to incorporate it into the kernel.  (I am one of those people that 
believe that Linux should support EVERY file system, no matter how old or 
obscure.)

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
