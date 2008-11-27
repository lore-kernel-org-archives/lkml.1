Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYK0QWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYK0QWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYK0QVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:21:37 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:30623 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYK0QVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:21:36 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH -v3 5/8] fsnotify: unified filesystem notification
 backend
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 17:21:34 +0100
Message-Id: <1227802894.4454.1768.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:

> +void fsnotify_kill_group(struct fsnotify_group *group)
> +{
> +       /* clear the notification queue of all events */
> +       fsnotify_clear_notif(group);
> +
> +       kfree(group);
> +}

We're not sending any signals ;-) destroy or free perhaps?

