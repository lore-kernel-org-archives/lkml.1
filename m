Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbXD0UZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbXD0UZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXD0UZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:25:54 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3052 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbXD0UZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:25:02 -0400
X-Greylist: delayed 746 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 16:25:01 EDT
From: "Miquel van Smoorenburg" <mikevs@xs4all.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
X-Newsgroups: lists.linux.kernel
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
 <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
 <20070427193130.GD5967@schatzie.adilger.int>
Organization: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1HhWnt-0003ku-1S@n2o.xs4all.nl>
Date: Fri, 27 Apr 2007 22:12:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org> you write:
>I was actually _really_ hoping that somebody would come along and tell 
>everybody that this whole journal-logging is stupid, and that it's just 
>better to not ever re-write blocks on disk, but instead write to new 
>blocks with version numbers (and not re-use old blocks until new versions 
>are stable on disk).
>
>There was even somebody who did something like that for a PhD thesis, I 
>forget the details (and it apparently died when the thesis was presumably 
>accepted ;).

If you mean tux2, it died because of patent issues:

http://www.uwsg.iu.edu/hypermail/linux/kernel/0208.3/0332.html

Mike.
