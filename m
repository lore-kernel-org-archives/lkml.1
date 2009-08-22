Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZHVUqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZHVUqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZHVUqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:46:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:57224 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbZHVUqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:46:50 -0400
Date: Sat, 22 Aug 2009 16:46:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <20090822201558.GA17955@infradead.org>
Message-ID: <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan> <00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com> <alpine.DEB.2.00.0908090605080.16485@p34.internal.lan> <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan> <20090816022331.GA2309@infradead.org>
 <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan> <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan> <20090822142550.GA10003@infradead.org> <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Aug 2009, Christoph Hellwig wrote:

> On Sat, Aug 22, 2009 at 10:45:13AM -0400, Justin Piszcz wrote:
>>> Yes, entirely possible.   All the crypto loop / dm implementation used
>>> to have a tendency to never complete I/O once in a while, although that
>>> didn't happen anymore recently.
>>
>> Ok,
>>
>> What is the best way to debug the issue? git bi-sects between 2.6.29.x
>> and 2.6.31-rc6? or?
>
> Well, that would be a good way to find it.  But I'm personally not
> interested in spending much time on debugging a problem if it only
> happens with fishy out of tree modules.
>

.. No out of tree modules are used ..

Here is the kernel config used:
http://home.comcast.net/~jpiszcz/20090822/config.txt

After 24hrs of various tar-like read/write/verify I/O, the error usually 
recurs.

Justin.
