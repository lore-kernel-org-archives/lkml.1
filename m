Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZIVP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZIVP5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZIVP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbZIVP5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:57:36 -0400
Message-ID: <4AB8F3EC.6050607@redhat.com>
Date: Tue, 22 Sep 2009 10:57:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@lst.de>, t-sato@yk.jp.nec.com,
       m-hamaguchi@ys.jp.nec.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Do not allow umounting of frozen filesystems
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp> <4A9692CF.80508@oss.ntt.co.jp> <20090922110737.GL5858@ZenIV.linux.org.uk>
In-Reply-To: <20090922110737.GL5858@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
...

> IOW, I'd rather add two new ioctls (check if frozen/thaw), both by
> bdev.  On top of the first two patches in this set.

> Comments?

The check ioctls would be very very useful, IMHO.  Many filesystem tools
refuse to operate on a mounted filesystem, but in some cases it'd be
safe to do readonly operations on a frozen, mounted fs.

-Eric
