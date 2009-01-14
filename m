Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbZANFQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbZANFQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZANFQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:16:20 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:46262 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbZANFQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:16:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgFAA8BbUlMQWt2/2dsb2JhbACBbJMHuFCFbw
Date: Wed, 14 Jan 2009 00:16:02 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Greg KH <gregkh@suse.de>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [ltt-dev] [PATCH 1/2] Make lttctl mount debugfs automatically
Message-ID: <20090114051602.GA14786@Krystal>
References: <49646208.7070607@cn.fujitsu.com> <4964BA2B.30200@polymtl.ca> <AA3F776E5F6246859F1978B7C7CF1919@zhaoleiwin> <20090108144430.GA3778@Krystal> <7C0A417AB5B84CDCB9A9484C4E13A08C@zhaoleiwin> <20090109033021.GA25504@Krystal> <20090113235419.GA20644@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090113235419.GA20644@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:15:23 up 13 days,  5:13,  1 user,  load average: 0.46, 0.46,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (gregkh@suse.de) wrote:
> On Thu, Jan 08, 2009 at 10:30:22PM -0500, Mathieu Desnoyers wrote:
> > * Zhaolei (zhaolei@cn.fujitsu.com) wrote:
> > > * From: "Mathieu Desnoyers" <compudj@krystal.dyndns.org>
> > > >* Zhaolei (zhaolei@cn.fujitsu.com) wrote:
> > > >> * From: "Pierre-Marc Fournier" <pierre-marc.fournier@polymtl.ca>
> > > >> > Zhaolei wrote:
> > > >> >> lttctl need debugfs mounted,
> > > >> >> This patch make lttctl mount debugfs automatically when it is not mounted.
> > > >> >> 
> > > >> > 
> > > >> > Isn't having a utility such as lttctl mount filesystems against standard
> > > >> > unix semantics? Can you give an example of another standard command that
> > > >> > uses a filesystem and that tries to mount it if it isn't already
> > > >> > mounted? 
> > > >> Hello, Pierre-Marc,
> > > >> 
> > > >> I can give a an example.
> > > >> It is SystemTap.
> > > >> 
> > > > 
> > > > No offence, but can you find an example which is not explicitly
> > > > described as "bad taste" example by many people in the Linux kernel
> > > > community ?
> > > Hello, Mathieu
> > > 
> > > I can't find another example of mounting debugfs automatically.
> 
> Have you looked?  openSUSE mounts it automatically, and I think Fedora
> also does so.
> 

It makes sense for a whole distribution to mount debugfs automatically,
but is it OK for a single userspace application to have this kind of
behavior ?

Mathieu

> thanks,
> 
> greg k-h
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
