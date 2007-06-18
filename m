Return-Path: <linux-kernel-owner+w=401wt.eu-S933394AbXFRW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394AbXFRW4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbXFRW4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:56:05 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:56190 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282AbXFRW4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:56:03 -0400
Date: Mon, 18 Jun 2007 15:56:03 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Bodo Eggert <7eggert@gmx.de>, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <20070618222656.GB25089@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0706181551350.25913@blackbox.fnordora.org>
References: <8wsCC-3wf-21@gated-at.bofh.it> <8wsW4-3UY-3@gated-at.bofh.it>
 <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it>
 <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it>
 <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org>
 <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org>
 <20070618222656.GB25089@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1637209403-1182207363=:25913"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1637209403-1182207363=:25913
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 19 Jun 2007, Jörn Engel wrote:

> On Mon, 18 June 2007 18:10:21 -0400, Theodore Tso wrote:
>> On Mon, Jun 18, 2007 at 02:31:14PM -0700, H. Peter Anvin wrote:
>>> And that makes them different from extended attributes, how?
>>>
>>> Both of these really are nothing but ad hocky syntactic sugar for
>>> directories, sometimes combined with in-filesystem support for small
>>> data items.
>>
>> There's a good discussion of the issues involved in my LCA 2006
>> presentation....  which doesn't seem to be on the LCA 2006 site.  Hrm.
>> I'll have to ask that this be fixed.  In any case, here it is:
>>
>> 	http://thunk.org/tytso/forkdepot.odp
>
> The main difference appears to be the potential size.  Both extended
> attributes and forks allow for extra data that I neither want or need.
> But once the extra space is large enough to hide a rootkit in, it
> becomes a security problem instead of just something pointless.
>
> Pointless here means that _I_ don't see the point.  Maybe there are
> valid uses for extended attributes.  If there are, noone has explained
> them to me yet.

Most of the extended attribute systems I have seen have been a set of 
flags.  "If this bit is set, the user can do thus to this object." 
Sometimes it is a named attribute that is attached to the object.

Forks tend to be "this blob of data is attached to this object".

With forks, the choices tend to be a lot more arbitrary.

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
--8323328-1637209403-1182207363=:25913--
