Return-Path: <linux-kernel-owner+w=401wt.eu-S1750878AbZH1WuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbZH1WuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZH1WuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:50:20 -0400
Received: from tservice.ru ([195.178.208.66]:43635 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZH1WuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:50:19 -0400
Date: Sat, 29 Aug 2009 02:50:20 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, viro@zeniv.linux.org.uk,
       alan@linux.intel.com, hch@infradead.org
Subject: Re: [PATCH 1/9] task_struct: add PF_NONOTIFY for fanotify to use
Message-ID: <20090828225020.GA11259@ioremap.net>
References: <20090828185542.8014.22791.stgit@paris.rdu.redhat.com> <20090828223626.GA8283@ioremap.net> <1251499168.28787.2.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251499168.28787.2.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 06:39:28PM -0400, Eric Paris (eparis@redhat.com) wrote:
> > Is there a way to get old-school notifications with the object
> > information instead of opened file desriptor, which may suffer rlimit
> > problems and scalability issues with too many opened/closed descriptors?
> 
> Use inotify.

I need pids.

-- 
	Evgeniy Polyakov
