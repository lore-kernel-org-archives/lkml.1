Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYLJNKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYLJNKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYLJNKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:10:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59744 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYLJNKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:10:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5545.1228914404@redhat.com>
References: <5545.1228914404@redhat.com> <1795455197.20081210132912@emcraft.com> <200812092044.40649.yur@emcraft.com> <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be> <503391615.20081210130113@emcraft.com> <20081210101745.GG28946@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Yuri Tikhonov <yur@emcraft.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Wolfgang Denk <wd@denx.de>,
       Detlev Zundel <dzu@denx.de>, linux-kernel@vger.kernel.org,
       Milton Miller <miltonm@bga.com>, linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Ilya Yanok <yanok@emcraft.com>
Subject: Re: Re[2]: [PATCH] fork_init: fix division by zero
Date: Wed, 10 Dec 2008 13:09:38 +0000
Message-ID: <5572.1228914578@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Ummm...  On powerpc, I believe rotate-left would be a division as it does the
> bit-numbering and the bit direction the opposite way to more familiar CPUs
> such as x86.

Actually, I'm not sure that's true.  Sometimes powerpc makes my head hurt:-)

David
