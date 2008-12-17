Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759906AbYLQHhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbYLQHhl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYLQHhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:37:31 -0500
Received: from tundra.namei.org ([65.99.196.166]:3820 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYLQHha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:37:30 -0500
Date: Wed, 17 Dec 2008 18:37:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/15] sanitize audit_mq_notify()
In-Reply-To: <E1LCohU-0000BE-T6@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812171837020.22856@tundra.namei.org>
References: <E1LCohU-0000BE-T6@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> 
> * don't copy_from_user() twice
> * don't bother with allocations
> * don't duplicate parts of audit_dummy_context()
> * make it return void
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
