Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYB1AF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYB1AF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYB1AFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:05:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:44087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754834AbYB1AFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:05:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18vDTww4mUvxdMCiLlQSe8B/Bw5Q+BVweZ+prC5LH
	QqyPZXKMAcjVFd
Subject: Re: Linux 2.6.24.3
From: Mike Galbraith <efault@gmx.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080227134945.c1430710.randy.dunlap@oracle.com>
References: <20080226010024.GA26889@suse.de>
	 <20080225195229.11ec1f12.randy.dunlap@oracle.com>
	 <20080226041545.GA30567@suse.de>
	 <20080227134945.c1430710.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 01:05:41 +0100
Message-Id: <1204157141.8466.4.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 13:49 -0800, Randy Dunlap wrote:
> On Mon, 25 Feb 2008 20:15:45 -0800 Greg KH wrote:

> > Is this a regression from 2.6.24.2?
> 
> Yes.
> 
> > If so, any ideas which patch caused it?

Which ever one that added this.

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index f30fa92..4b32bb1 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -217,6 +217,7 @@ unifdef-y += i2o-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
+unifdef-y += if_addrlabel.h
 unifdef-y += if_arp.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h


