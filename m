Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYKZIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYKZIvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYKZIq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:46:26 -0500
Received: from netgear.net.ru ([195.178.208.66]:43120 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbYKZIqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:46:24 -0500
Date: Wed, 26 Nov 2008 11:46:19 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john@johnmccutchan.com, arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de,
       rlove@rlove.org, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, davidn@davidnewall.com,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-ID: <20081126084619.GA22577@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net> <20081126003825.2b9a92be.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126003825.2b9a92be.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:38:25AM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> That means that the code delivers non-unique process identifiers to
> userspace.  A client gets pid=42 but there are seven processes on the
> machine with that pid.  Problem.

Because of namespaces I suppose? This is not a problem for those who
run in the same namespace, otherwise we can add nsproxy ID if needed for
anyone.

-- 
	Evgeniy Polyakov
