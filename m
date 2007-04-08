Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXDHSOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXDHSOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXDHSOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:14:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXDHSOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:14:04 -0400
Message-ID: <46193048.6000606@zytor.com>
Date: Sun, 08 Apr 2007 11:11:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org>
In-Reply-To: <20070407233037.GA16508@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Apr 07, 2007 at 04:36:33PM -0400, Theodore Tso wrote:
>> this functionality, and it is highly questionable how useful it is,
>> anyway.  If you use telldir/seekdir and keep the cookie for a long
>> time, even the POSIX-provided guarantees about files that are created
>> and deleted between the telldir() and seekdir() points in time makes
>> its utility highly dubious.
> 
> It's not going to solve anything at all.  We can't stop supporting
> functionality that has been there forever. 

Well, the question is if you can keep the seekdir/telldir cookie around 
as a pointer -- preferrably in userspace, of course.  You would 
presumably garbage-collect them on closedir() -- there is no other point 
at which you could.

I personally suspect that hch is right -- this stuff has been there 
since time immemorial and it'll be hard or impossible to deprecate it.

	-hpa
