Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYHAQfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYHAQfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYHAQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:34:55 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:63388 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYHAQez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fcJ0Ek2S8i/iDSg1I06f0U7U4woyXSEu+XMOpWeb1cks6AYBXqV6K4QLc5CrqRAxHY
         wnpEjRU+83QIjE9YGoH5A73rh2XsnIYGO4Y7295QDxsAYxFz7rHCfpQpvtUEizKOOybW
         z3ep8P/HFa/9q7Szq8+NIuUHrYiXW7MuPPZJk=
Message-ID: <48f7fe350808010934k32b9de09we657e57087a3e3a5@mail.gmail.com>
Date: Fri, 1 Aug 2008 12:34:53 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Ryan Hope" <rmh3093@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: reiser4 for 2.6.27-rc1
In-Reply-To: <20080801162548.GD8654@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com>
	 <20080801162548.GD8654@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm, removing the plugin support might not be so hard....  I might
have to try this... I am not impressed with btrfs yet.
-Ryan

On Fri, Aug 1, 2008 at 12:25 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Aug 01, 2008 at 09:49:55AM -0400, Ryan Hope wrote:
>> Why is reiser4 still not in a vanilla kernel for testing. I have had
>> to apply the reiser4 patches from -mm kernels to vanilla based
>> patchset for over a year now. Reiser4 works fine, what will it take to
>> get it included in vanilla? Here is a patch to add reiser4 to
>> 2.6.27-rc1:
>>
>> http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch
>
> The reasons laid out in these web pages haven't changed.
>
> http://kernelnewbies.org/WhyReiser4IsNotIn
> http://lkml.org/lkml/2006/7/28/180
> http://www.gossamer-threads.com/lists/engine?do=post_view_flat;post=668645;page=1;sb=post_latest_reply;so=ASC;mh=25;list=linux
>
> Now that Hans is out of the picture, and Namesys seems to have
> collapsed, maybe someone can yank out the plugin architecture that
> Linus and others have objected to, which as near as I could tell was
> part of the Namesys's somewhat dodgy business plan of creating and
> selling (possibly proprietary; not sure what license they were going
> to be under) plugin modules for Reiser4 to make money.  The other
> issue that was raised during the review were some locking issues
> raised by Al Viro, if memory serves correctly.  I'm not sure if they
> were ever fixed; at least initially they were brushed aside by Hans.
>
> In the meantime, people who really like reiser4 might want to take a
> look at btrfs; it has a number of the same design ideas that reiser3/4
> had --- except (a) the filesystem format has support for some advanced
> features that are designed to leapfrog ZFS, (b) the maintainer is not
> a crazy man and works well with other LKML developers (free hint: if
> your code needs to be reviewed to get in, and reviewers are scarce;
> don't insult and abuse the volunteer reviewers as Hans did --- Not a
> good plan!).
>
>                                                - Ted
>
