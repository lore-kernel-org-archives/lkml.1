Return-Path: <linux-kernel-owner+w=401wt.eu-S1750871AbYEERvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871AbYEERvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYEERv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:51:26 -0400
Received: from xenotime.net ([66.160.160.81]:39655 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751125AbYEERvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:51:25 -0400
Date: Mon, 5 May 2008 10:51:17 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Jesper Krogh <jesper@krogh.cc>
cc: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
In-Reply-To: <481F4728.9050100@krogh.cc>
Message-ID: <Pine.LNX.4.64.0805051050350.27703@shark.he.net>
References: <4819E316.7000607@krogh.cc>  <20080501223938.921f7cd2.akpm@linux-foundation.org>
  <481ACEC4.2040205@krogh.cc> <481B3115.30705@krogh.cc>
 <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>
 <481B70F9.6000201@krogh.cc> <481F4728.9050100@krogh.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Jesper Krogh wrote:

> Jesper Krogh wrote:
> > Ray Lee wrote:
> > > BTW, I may have missed this earlier, but does it happen *anywhere* on
> > > the troublesome filesystem (ie, in a newly created subdirectory)?
> > 
> > Yes. It is reproducible on a newly created subdirectory on the
> > filesystem.
> 
> Now I've created a new filesystem. (resized the original LVM-volume to half
> and created a new ext3 one next to it). The problem persists on this new
> filesystem.
> 
> Just guessing, can there be something timing related in clearing the FS-cache
> for the filesystem?
> 
> Any other suggestions/pointers.

Hi,

Has anyone else been able to reproduce this problem?

I ran the test program overnight with no problem.

-- 
~Randy
