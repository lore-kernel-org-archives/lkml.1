Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZKCBDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZKCBDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbZKCBDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:03:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553AbZKCBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:03:04 -0500
Date: Mon, 2 Nov 2009 17:02:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] Use unified UUID/GUID definition in gfs2
Message-Id: <20091102170249.d1bf0aea.akpm@linux-foundation.org>
In-Reply-To: <1257209088.30470.1171.camel@yhuang-dev.sh.intel.com>
References: <1255501807.6047.1193.camel@yhuang-dev.sh.intel.com>
	<20091101093545.a7a4693a.akpm@linux-foundation.org>
	<1257123583.30470.1161.camel@yhuang-dev.sh.intel.com>
	<20091102150221.948d8427.akpm@linux-foundation.org>
	<1257209088.30470.1171.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Nov 2009 08:44:48 +0800
Huang Ying <ying.huang@intel.com> wrote:

> For stuff of no use to user space, I think it can be enclosed into
> 
> #ifdef __KERNEL__
> #endif

It can, but that's ugly.  Clearly separating the inclusions into uuid-kernel.h
and uuid-user-h is nicer, no?
