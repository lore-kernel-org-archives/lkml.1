Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0BVTne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:43:34 -0500
Received: from mail.perches.com ([173.55.12.10]:1135 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab0BVTnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:43:33 -0500
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
From: Joe Perches <joe@perches.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20100222141934.GA9030@darkstar>
References: <20100222141934.GA9030@darkstar>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 11:43:31 -0800
Message-ID: <1266867811.10646.196.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 22:19 +0800, Dave Young wrote:
> hexdump stuff in kernel.h should be put into a standalone head file
 
I think it'd be clearer to have logging functions
in kernel.h split into a separate header or grouped
a bit better in kernel.h.

I would have kernel.h #include that header though
rather than splitting out things like hexdump functions
into a separate file requiring yet another #include in
source files.

http://lkml.org/lkml/2009/12/16/77
http://lkml.org/lkml/2007/11/29/507


