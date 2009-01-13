Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZAMX7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZAMX7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbZAMX7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:59:22 -0500
Received: from mx1.suse.de ([195.135.220.2]:40424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669AbZAMX7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:59:21 -0500
Date: Tue, 13 Jan 2009 15:54:19 -0800
From: Greg KH <gregkh@suse.de>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [ltt-dev] [PATCH 1/2] Make lttctl mount debugfs automatically
Message-ID: <20090113235419.GA20644@suse.de>
References: <49646208.7070607@cn.fujitsu.com> <4964BA2B.30200@polymtl.ca> <AA3F776E5F6246859F1978B7C7CF1919@zhaoleiwin> <20090108144430.GA3778@Krystal> <7C0A417AB5B84CDCB9A9484C4E13A08C@zhaoleiwin> <20090109033021.GA25504@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109033021.GA25504@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 10:30:22PM -0500, Mathieu Desnoyers wrote:
> * Zhaolei (zhaolei@cn.fujitsu.com) wrote:
> > * From: "Mathieu Desnoyers" <compudj@krystal.dyndns.org>
> > >* Zhaolei (zhaolei@cn.fujitsu.com) wrote:
> > >> * From: "Pierre-Marc Fournier" <pierre-marc.fournier@polymtl.ca>
> > >> > Zhaolei wrote:
> > >> >> lttctl need debugfs mounted,
> > >> >> This patch make lttctl mount debugfs automatically when it is not mounted.
> > >> >> 
> > >> > 
> > >> > Isn't having a utility such as lttctl mount filesystems against standard
> > >> > unix semantics? Can you give an example of another standard command that
> > >> > uses a filesystem and that tries to mount it if it isn't already
> > >> > mounted? 
> > >> Hello, Pierre-Marc,
> > >> 
> > >> I can give a an example.
> > >> It is SystemTap.
> > >> 
> > > 
> > > No offence, but can you find an example which is not explicitly
> > > described as "bad taste" example by many people in the Linux kernel
> > > community ?
> > Hello, Mathieu
> > 
> > I can't find another example of mounting debugfs automatically.

Have you looked?  openSUSE mounts it automatically, and I think Fedora
also does so.

thanks,

greg k-h
