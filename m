Return-Path: <linux-kernel-owner+w=401wt.eu-S1764639AbYD1AOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764639AbYD1AOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYD1AN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:13:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:28044 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYD1ANz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ADa9n19fdGk/SjDc7Ymtfkt4rVlBY/GP+4X07yEVLSfBNmxKLgKdVjpWsOE6HqepJoat+Wp3dRDI9TgB3kmnyIy3NSYSPMkrfkwjfYQdtAiR282SoYCnvC3PaBYwU0AIgFhy/XfswTHWF/z59cN96J8+6kjOTj3iklICYO9A4rY=
Message-ID: <ed038eb20804271713n79ff9b0cxa6906867d7a20f9@mail.gmail.com>
Date: Mon, 28 Apr 2008 02:13:55 +0200
From: "Carl Henrik Lunde" <chlunde@ping.uio.no>
To: "Soeren Sandmann" <sandmann@daimi.au.dk>
Subject: Re: stat benchmark
Cc: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       alexl@redhat.com
In-Reply-To: <ye8iqy23mhb.fsf@camel27.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
	 <20080425194845.GE21193@mit.edu> <ye8iqy23mhb.fsf@camel27.daimi.au.dk>
X-Google-Sender-Auth: fde0beb32c325916
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 1:29 AM, Soeren Sandmann <sandmann@daimi.au.dk> wrote:
[...]
>  For a directory of ~2360 files, chunks of a 1000 files is actually
>  surprisingly worse than statting all of the files at once:
>
>     Time to stat 1000 files: 1.008735 s
>     Time to stat 1000 files: 0.738936 s
>     Time to stat 366 files: 0.217002 s
>
>  I guess this just shows that seeks really is pretty much all that
>  matters. Glib should maybe use a larger chunk size.

I agree, if I remember correctly I did not find a directory on my local
disk where the best result was to sort a chunk instead of the complete
directory.

>  I don't know if a general library outside glib would be useful. It
>  seems that just telling people to "sort by inode before statting"
>  would be just as effective as telling them "use this optimized
>  library".

A library (like glib) could disable the feature for solid-state drives
and perhaps implement an alternative strategy for filesystems without
any inode/sector correlation.

So I think we should tell people to use glib. :-)

-- 
Carl Henrik
