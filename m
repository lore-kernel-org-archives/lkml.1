Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZIGWTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZIGWTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZIGWTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:19:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:46913 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZIGWTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:19:07 -0400
Date: Tue, 8 Sep 2009 08:18:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 4/8] Simplify exec_permission_lite(), part 3
In-Reply-To: <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0909080818310.11493@tundra.namei.org>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Linus Torvalds wrote:

> The generic inode_permission() code does things like checking MAY_WRITE
> and devcgroup_inode_permission(), neither of which are relevant for the
> light pathname walk permission checks (we always do just MAY_EXEC, and
> the inode is never a special device).
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
