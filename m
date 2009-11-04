Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZKDIHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZKDIHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZKDIHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:07:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36006 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZKDIHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:07:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w2UJ5tKAZUgiUrusKk1xyCwUSDsqAAdBHouqHE/2CQ91Yiqeb2h9Z0HN/8A3cejzi7
         ZU5iZexGwaKxzdZXYamIo6HeNv5QYE4D+uNvEOxZcacWeNyRomyECR4MWA/LfK2uWq3q
         MRG+OCeNutAPVMovFEPhTGhwODXkDsEtnfWx8=
MIME-Version: 1.0
In-Reply-To: <1257296148.2891.223.camel@dhcp231-106.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
	 <20091031184819.17244.55795.stgit@paris.rdu.redhat.com>
	 <20091103165947.35bd78d7@bike.lwn.net>
	 <1257296148.2891.223.camel@dhcp231-106.rdu.redhat.com>
Date: Wed, 4 Nov 2009 09:07:42 +0100
Message-ID: <19f34abd0911040007i738bfc4eq5481b6c85117d525@mail.gmail.com>
Subject: Re: [PATCH 10/10] send events using read
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       linus-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, agruen@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/4 Eric Paris <eparis@redhat.com>:
> On Tue, 2009-11-03 at 16:59 -0700, Jonathan Corbet wrote:
>> Hi, Eric,
>>
>> This is not a full review, but I did notice a problem as I was trying to
>> figure out the new API...
>
> This is a rip off of inotify which was introduced in commit 3632dee2f8b
> from Vegard Nossum back in January.  I can't seem to find any discussion
> of this before it went into Linus' tree, so if someone knows how this
> patch got to Linus and what was said about it, I'd like to know.  Thanks
> for unwittingly finding and inotify bug!

I don't have a git tree handy, but I think this is the locking
imbalance fix. It went to the security list, so that's probably why
you didn't find it. As far as I can tell, the code in question was
wrong even before that patch, though.


Vegard
