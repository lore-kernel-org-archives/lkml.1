Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYL3Omp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYL3Omp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYL3Omf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:42:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39753 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYL3Ome (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:42:34 -0500
Date: Tue, 30 Dec 2008 15:55:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20081230145555.GN496@one.firstfloor.org>
References: <20081229041352.6bbdf57c@tpl> <20081229124151.GA29634@redhat.com> <20081229152732.GH496@one.firstfloor.org> <20081230055956.1747bd86@tpl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230055956.1747bd86@tpl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:59:56AM -0700, Jonathan Corbet wrote:
> On Mon, 29 Dec 2008 16:27:32 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I would prefer O_LOCK_FLAGS bit too. The global lock is not very nice
> > and I don't doubt someone will come up with a workload which
> > pounds on it.
> 
> Seems hard to imagine that it would be worse than the longstanding BKL
> situation.  

As long as noone else uses it too BKL is faster than a mutex.

-Andi

-- 
ak@linux.intel.com
