Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYLMDTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYLMDTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 22:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYLMDTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 22:19:23 -0500
Received: from genesysrack.ru ([195.178.208.66]:42562 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYLMDTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 22:19:23 -0500
Date: Sat, 13 Dec 2008 06:19:20 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC PATCH -v4 11/14] fsnotify: include pathnames with entries when possible
Message-ID: <20081213031920.GG807@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215212.27112.73418.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212215212.27112.73418.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 04:52:12PM -0500, Eric Paris (eparis@redhat.com) wrote:
> When inotify wants to send events to a directory about a child it includes
> the name of the original file.  This patch collects that filename and makes
> it available for notification.

What about extending fsnotify with attributes so that there would be no
problems extending it with new events and data sent to userspace?


-- 
	Evgeniy Polyakov
