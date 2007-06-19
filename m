Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXFSWIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXFSWIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXFSWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:07:55 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58052
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbXFSWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:07:54 -0400
Date: Tue, 19 Jun 2007 15:07:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Chris Snook <csnook@redhat.com>, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
In-Reply-To: <20070619204317.GR10008@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0706191505130.26701@asgard.lang.hm>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com>
 <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com>
 <20070619204317.GR10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Lennart Sorensen wrote:

> On Tue, Jun 19, 2007 at 02:03:07PM -0400, Chris Snook wrote:
>> I pointed out NetApp's .snapshot directories because that's a method that
>> uses legal path character, but doesn't break anything.  With this method,
>> userspace tools will have to be taught that : is suddenly a special
>> character.  Userspace already knows that files beginning with . are special
>> and treat them specially. We don't need a new special character for every
>>  new feature.  We've got one, and it's flexible enough to do what you want,
>> as proven by NetApp's extremely successful implementation.  Perhaps you
>> want a slightly different interface from what NetApp has implemented, but
>> what you're suggesting will change the default behavior of basic tools like
>> tar and ls.  This is not a good thing.
>
> I think I used one of those systems once (or at least another one with
> .snapshot feature).  It managed to completely avoid user space problems
> by never actually showing .snapshot in directory listings, but you could
> always cd to it or refer to it explicitly.  You never risked having tar
> or find or anything else accidentally pick it up.  Very nice interface.

since anything starting with . is considered a 'hidden' file per *nix 
tradition it's ignored by many programs and optionally ignored by most 
others (and anything that doesn't ignore . files when presending files to 
the user has many other problems on modern desktop systems anyway ;-)

the only trouble I ever had with the .snapshot approach is when tar or 
find would decend down into the .snapshot when I didn't really intend for 
it to do so.

David Lang
