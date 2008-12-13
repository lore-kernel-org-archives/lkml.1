Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYLMDXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYLMDXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 22:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYLMDW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 22:22:57 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:43808 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbYLMDW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 22:22:56 -0500
Date: Sat, 13 Dec 2008 06:22:55 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC PATCH -v4 13/14] inotify: reimplement inotify using fsnotify
Message-ID: <20081213032255.GH807@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215222.27112.33426.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212215222.27112.33426.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 04:52:23PM -0500, Eric Paris (eparis@redhat.com) wrote:
> Yes, holy shit, I'm trying to reimplement inotify as fsnotify...

While you are at it, please update inode_setattr() so that it dropped
inotify watches if new permissions do not allow to read data.

-- 
	Evgeniy Polyakov
