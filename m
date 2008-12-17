Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752011AbYLQT05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbYLQT05 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYLQT0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:26:47 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:62266 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLQT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:26:46 -0500
Message-ID: <7e0fb38c0812171126q20f70c22i49be021f07108062@mail.gmail.com>
Date: Wed, 17 Dec 2008 14:26:45 -0500
From: "Eric Paris" <eparis@parisplace.org>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [PATCH] filesystem notification: create fs/notify to contain all fs notification
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au, ttb@tentacle.dhs.org, rml@novell.com,
        kosaki.motohiro@jp.fujitsu.com, zbr@ioremap.net
In-Reply-To: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 1:59 PM, Eric Paris <eparis@redhat.com> wrote:
> Creating a generic filesystem notification interface, fsnotify, which will be
> used by inotify, dnotify, and eventually fanotify is really starting to
> clutter the fs directory.  This patch simply moves inotify and dnotify into
> fs/notify/inotify and fs/notify/dnotify respectively to make both current fs/
> and future notification tidier.
>
> Signed-off-by: Eric Paris <eparis@redhat.com>

For those of you who prefer a more readable diff (aka git format-patch
-M), its the exact same patch as here:

http://marc.info/?l=linux-kernel&m=122935950317407&w=2
