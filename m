Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbZFRLbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbZFRLbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZFRLa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:30:56 -0400
Received: from tundra.namei.org ([65.99.196.166]:40246 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbZFRLaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:30:55 -0400
Date: Thu, 18 Jun 2009 21:30:24 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jan Blunck <jblunck@suse.de>
cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, vaurora@redhat.com, hch@lst.de,
       miklos@szeredi.hu, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] VFS: Introduce dput() variant that maintains a
 kill-list
In-Reply-To: <1245271510-31542-7-git-send-email-jblunck@suse.de>
Message-ID: <alpine.LRH.2.00.0906182129530.24774@tundra.namei.org>
References: <1245271510-31542-1-git-send-email-jblunck@suse.de> <1245271510-31542-7-git-send-email-jblunck@suse.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Jan Blunck wrote:

> This patch introduces a new variant of dput(). This becomes necessary to
> prevent a recursive call to dput() from the union mount code.

Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris <jmorris@namei.org>
