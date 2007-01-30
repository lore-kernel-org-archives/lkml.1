Return-Path: <linux-kernel-owner+w=401wt.eu-S965599AbXA3Qm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965599AbXA3Qm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965594AbXA3Qm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:42:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965571AbXA3Qm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:42:56 -0500
Message-ID: <45BF754A.1030307@redhat.com>
Date: Tue, 30 Jan 2007 11:41:46 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, dev@openvz.org
Subject: Re: [PATCH 1/2] add lazy_getattr and lazy_readdir patches that defer
 i_ino assignment
References: <200701301538.l0UFcGNX027715@dantu.rdu.redhat.com> <45BF7499.1000805@sw.ru>
In-Reply-To: <45BF7499.1000805@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
> Jeff,
> 
> taking into account the discussion about unawarness/uncertainty
> of whether *unique* inode number is needed at all on pipe fds and such
> do we need this at all?
> 
> Thanks,
> Kirill
>

Fair enough, perhaps we should just not worry about it, and assume that there 
might be collisions.

If so, I should probably just have Andrew withdraw the patch I submitted earlier 
to hash the inodes for pipefs. I'll look at other callers of new_inode and fix 
up any of the ones that need fixing.

Does that seem like the most reasonable approach?

-- Jeff
