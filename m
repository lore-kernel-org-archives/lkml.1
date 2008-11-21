Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYKUKM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYKUKM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYKUKMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:12:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45629 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbYKUKMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:12:46 -0500
Date: Fri, 21 Nov 2008 11:12:09 +0100
From: Karel Zak <kzak@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hooanon05@yahoo.co.jp, tomas@slax.org, linux-kernel@vger.kernel.org,
       akinobu.mita@gmail.com, util-linux-ng@vger.kernel.org
Subject: Re: [PATCH] loop file resizable
Message-ID: <20081121101209.GJ2961@nb.net.home>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl> <20081120132654.4c649eb0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120132654.4c649eb0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:26:54PM -0800, Andrew Morton wrote:
> Well if we're going to do this then I guess we'll need to tell the
> util-linux people about it, as users will be needing some tool with
> which to access the new fucntionality.
> 
> Presumably that would be some enhancement to losetup, or perhaps a new
> tool.  Could the util-linux people please have a think about this and
> comment?

 It shouldn't be a problem to extend the current losetup(8). I have no
 problem with this change.

> Also, I'm not sure that the user interface is terribly good.  The user
> must extend the file size and then we tell the loop driver to use all
> of the new file size.  it would be better (more flexible) to allow
> userspace to explicitly pass in the new size for the loop device.
>
> But I'm not sure that this is worth bothering about.

 I think the interface is useful and kernel side is pretty simple.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
