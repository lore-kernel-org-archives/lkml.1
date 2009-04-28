Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZD1J7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZD1J7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbZD1J7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:59:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758849AbZD1J7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:59:18 -0400
Date: Tue, 28 Apr 2009 05:59:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org, akpm@linux-foundation.org
Subject: Re: [PATCH 12/12] inotify: reimplement inotify using fsnotify
Message-ID: <20090428095916.GA14452@infradead.org>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com> <20090427215406.14161.88864.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427215406.14161.88864.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, one thing I noticed is that this adds tons of code despite making
dnotify and inotify use command infrastructure.  Do you already add
features not actually used by inotify and dnotify?

Anyway, real review will follow once I get a little time..

