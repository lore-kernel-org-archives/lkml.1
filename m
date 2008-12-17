Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757551AbYLQHmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYLQHmi (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbYLQHmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:42:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:2859 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYLQHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:42:08 -0500
Date: Wed, 17 Dec 2008 18:40:54 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/15] sanitize AUDIT_MQ_SENDRECV
In-Reply-To: <E1LCohe-0000C7-TH@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812171839080.22856@tundra.namei.org>
References: <E1LCohe-0000C7-TH@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> 
> * logging the original value of *msg_prio in mq_timedreceive(2)
>   is insane - the argument is write-only (i.e. syscall always
>   ignores the original value and only overwrites it).

I wonder if any existing certifications need to be amended.

> * merge __audit_mq_timed{send,receive}
> * don't do copy_from_user() twice
> * don't mess with allocations in auditsc part
> * ... and don't bother checking !audit_enabled and !context in there -
>   we'd already checked for audit_dummy_context().
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
