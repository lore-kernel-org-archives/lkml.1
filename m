Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753965AbYLQHZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYLQHZc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYLQHY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:24:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:1924 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYLQHY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:24:56 -0500
Date: Wed, 17 Dec 2008 18:24:40 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/15] sanitize audit_ipc_obj()
In-Reply-To: <E1LCoh0-00009T-Sd@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812171823430.22856@tundra.namei.org>
References: <E1LCoh0-00009T-Sd@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> +		struct {
> +			uid_t			uid;
> +			gid_t			gid;
> +			mode_t			mode;
> +			u32			osid;
> +		} ipc;

'osid' should be converted into 'secid' someday.


Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
