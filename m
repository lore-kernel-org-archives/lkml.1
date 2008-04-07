Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYDGLNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYDGLNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYDGLNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:13:08 -0400
Received: from lazybastard.de ([212.112.238.170]:47297 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYDGLNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:13:07 -0400
Date: Mon, 7 Apr 2008 13:12:50 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch 8/15] fs/logfs/inode.c
Message-ID: <20080407111249.GF22431@logfs.org>
References: <20080401181308.512473173@logfs.org> <20080401181332.853833008@logfs.org> <9c9fda240804032357i36e7eac0q1c639a017b27af42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c9fda240804032357i36e7eac0q1c639a017b27af42@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 April 2008 15:57:08 +0900, Kyungmin Park wrote:
> 
> Same reason, 'read_inode' is removed.
> 
> After some works, it can compile but there's undefined symbols.
> WARNING: "swapper_space" [fs/logfs/logfs.ko] undefined!
> WARNING: "add_to_page_cache_lru" [fs/logfs/logfs.ko] undefined!
> WARNING: "inode_lock" [fs/logfs/logfs.ko] undefined!
> 
> Which kernel version do you use?

2.6.24, until today.  I've updated my compat patch here:
http://lazybastard.org/~joern/patches/logfs.patch.769

It should work on all kernel from 2.6.21 to current git.

Thanks for pointing it out.

Jörn

-- 
They laughed at Galileo.  They laughed at Copernicus.  They laughed at
Columbus. But remember, they also laughed at Bozo the Clown.
-- unknown
