Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYH3Mcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYH3Mcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 08:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYH3McY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 08:32:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:50206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYH3McY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 08:32:24 -0400
Message-ID: <48B93D68.6040506@kernel.org>
Date: Sat, 30 Aug 2008 14:30:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Archie Cobbs <archie@dellroad.org>
CC: Mike Hommey <mh@glandium.org>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
References: <1219947544-666-1-git-send-email-tj@kernel.org>	 <20080829055000.GB18930@glandium.org> <48B78EBA.609@kernel.org> <3bc8237c0808291150t2f18ba64vf445bdf4c2c8360c@mail.gmail.com>
In-Reply-To: <3bc8237c0808291150t2f18ba64vf445bdf4c2c8360c@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 Aug 2008 12:31:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Archie Cobbs wrote:
>> Thought about that but it's really no different from nbd or loop
>> depending on your application and block devices don't really implement
>> the file operations so it won't have too much in common with FUSE.
> 
> I think BUSE would be useful. For one, it allows you to avoid problems with
> the extra caching you get with a loopback device. And NBD is too limiting
> for some applications.
> 
> For my half-ignorant analysis of the caching issues, see:
>   http://code.google.com/p/s3backer/wiki/PerformanceConsiderations#Caching
> 
> This is also an example of an application where NBD doesn't suffice.
> 
>> Also, there's the complication of going out to disk for more memory cases.
> 
> Not sure what you mean exactly (my fault), but it seems BUSE would have fewer
> places for memory problems (including deadlocks) than loopback over FUSE,
> which is the only way to do this kind of stuff now.

Yeah, compared to loopback over FUSE, anything would have less
problem. :-) I don't know much about nbd but it's pretty much solving
the same problem so I think it's logical to extend nbd including
giving it a new transport if necessary?  Or is there something
fundamentally better when it's done via FUSE?

Thanks.

-- 
tejun
