Return-Path: <linux-kernel-owner+w=401wt.eu-S1763274AbZCQKjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274AbZCQKjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760931AbZCQKjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:39:31 -0400
Received: from tservice.net.ru ([195.178.208.66]:43634 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903AbZCQKja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:39:30 -0400
Date: Tue, 17 Mar 2009 13:39:24 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: hooanon05@yahoo.co.jp
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries
Message-ID: <20090317103923.GA4630@ioremap.net>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp> <20090316180538.GA7069@kroah.com> <7200.1237260402@jrobl> <20090317033747.GA17037@kroah.com> <7974.1237262747@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7974.1237262747@jrobl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 01:05:47PM +0900, hooanon05@yahoo.co.jp (hooanon05@yahoo.co.jp) wrote:
> Is the limit of PATH_MAX applied to the absolute path too?

No, only path used in the given operation (related or absolute) is
limited. If related path is converted into the absolute just for the
purpose of dump and not to be used in some syscall, it can have any
length, so you may need to rethink which pathes are presented in sysfs
and what should be moved outside.

-- 
	Evgeniy Polyakov
