Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZDGXPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZDGXPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZDGXMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZDGXMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:44 -0400
Date: Tue, 7 Apr 2009 16:06:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 03/13] fsnotify: add group priorities
Message-Id: <20090407160610.87d60a62.akpm@linux-foundation.org>
In-Reply-To: <20090327200520.32007.71108.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200520.32007.71108.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:20 -0400
Eric Paris <eparis@redhat.com> wrote:

> This introduces an ordering to fnotify groups.  It's most interesting because
> an HSM would need to run before a typical access notifier.  And an access
> control system would need to run between the two.

HSM == Hierarchical storage management?  google says "High School Musical" ;)

Some considerably more detailed explanation of the use-cases would be
helpful here.  It's all whizzing over my head.

