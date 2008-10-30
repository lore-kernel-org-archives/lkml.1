Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYJ3Njh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYJ3Njh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYJ3Nj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:39:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38309 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbYJ3Nj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:39:27 -0400
Message-ID: <4909B8D6.7070206@redhat.com>
Date: Thu, 30 Oct 2008 08:38:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Arthur Jones <ajones@riverbed.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       sct@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: ext3: slow symlink corruption on umount...
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081029210949.GA27274@mit.edu>
In-Reply-To: <20081029210949.GA27274@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Oct 29, 2008 at 03:36:33PM -0500, Eric Sandeen wrote:
>> Sorry for the silence, this is a nice bug you've found :)
>>
>> I'll look into it ...
> 
> You may want to take a quick look at this thread:
> 
>     http://lkml.org/lkml/2008/10/28/413
> 
> 					- Ted

I thought about that, but at least at first glance I don't see how the
gfp mask change would cause this behavior...?  At least, I don't think
we're seeing recursion back into the filesystem... but I'll ponder that.

(Also, Arthur reports seeing this as long ago as 2.6.9...)

-Eric
