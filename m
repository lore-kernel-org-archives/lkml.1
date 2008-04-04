Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYDDEUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYDDEUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 00:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYDDEUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 00:20:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbYDDEUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 00:20:43 -0400
Date: Thu, 3 Apr 2008 21:20:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2173
 tcp_mark_head_lost+0x173/0x1a0()
Message-Id: <20080403212038.ec0a4244.akpm@linux-foundation.org>
In-Reply-To: <20080403211913.3a0c1d00.akpm@linux-foundation.org>
References: <20080402224137.GB25768@curie-int.orbis-terrarum.net>
	<20080403211913.3a0c1d00.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 21:19:13 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> (cc netdev)
> 
> (and Rafael - I assume 2.6.24 didn't do this..)

urgh.

> On Wed, 2 Apr 2008 15:41:37 -0700 "Robin H. Johnson" <robbat2@gentoo.org> wrote:
> 
> > (Please CC, not on LKML).
> > 
> > One of the nodes in my web-serving cluster (isohunt.com) started showing this:
> > 
> > ------------[ cut here ]------------
> > WARNING: at net/ipv4/tcp_input.c:2173 tcp_mark_head_lost+0x173/0x1a0()
> > Modules linked in: lm85 hwmon_vid nfs lockd nfs_acl sunrpc bonding reiserfs k8temp hwmon i2c_nforce2 i2c_core sg
> > Pid: 32500, comm: php-cgi Not tainted 2.6.25-rc4-git2 #7

I misread that as -rc8.

We fixed a lot of stuff since -rc4.  Please retest current mainline?

