Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZCBWBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZCBWBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZCBWAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:00:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbZCBWAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:00:47 -0500
Date: Mon, 2 Mar 2009 14:00:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, greg@kroah.com, oliver@neukum.org,
       fweisbec@gmail.com, torvalds@linux-foundation.org
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless 
 support and add sysfs interface
Message-Id: <20090302140014.47b60178.akpm@linux-foundation.org>
In-Reply-To: <5aa163d00903021346g59d90241v11f384eb97641e43@mail.gmail.com>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
	<20090302130425.23cc628d.akpm@linux-foundation.org>
	<5aa163d00903021346g59d90241v11f384eb97641e43@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 16:46:01 -0500
Mike Murphy <mamurph@cs.clemson.edu> wrote:

> I had looked up another driver that used a header file in the stable
> tree

Yup, there's lots of crappy code in the tree, and it is regrettable
that maintainers continue to go ahead and merge that crappy code.

There's no easy fix for this - you need to be aware of what is right
and what is wrong, but you cannot look at existing code to determine
this :(

If the code which you're modifying is known (by you) to be wrong then
there are two schools of thought.  Some people do like to "match the
existing code".  I disagree with that.  The code's wrong dammit - we
might as well make the new code "right".  If that results in
inconsistent-looking code, well, so be it.  We shouldn't have merged
the wrong code in the first place.

