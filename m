Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbXGZIjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbXGZIjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbXGZIjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:39:00 -0400
Received: from main.gmane.org ([80.91.229.2]:34096 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbXGZIi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:38:59 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Re: -mm merge plans for 2.6.23
Date: Thu, 26 Jul 2007 09:38:45 +0100
Message-ID: <46A85D95.509@kingswood-consulting.co.uk>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<200707102015.44004.kernel@kolivas.org>	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	<46A57068.3070701@yahoo.com.au>	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	<46A58B49.3050508@yahoo.com.au>	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	<46A6CC56.6040307@yahoo.com.au> <p73abtkrz37.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: mail.artimi.com
User-Agent: IceDove 1.5.0.12 (X11/20070607)
In-Reply-To: <p73abtkrz37.fsf@bingen.suse.de>
Cc: ck@vds.kolivas.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> One simple way to fix this would be to implement a fadvise() flag
> that puts the dentry/inode on a "soon to be expired" list if there
> are no other references. Then if a dentry allocation needs more
> memory try to reuse dentries from that list (or better queue) first. Any other
> access will remove the dentry from the list. 
> 
> Disadvantage would be that the userland would need to be patched,
> but I guess it's better than adding very dubious heuristics to the
> kernel.

Are you going to change every single large memory application in the 
world? As I wrote before, it is *not* about updatedb, but about all 
applications that use a lot of memory, and then terminate.

Frank

