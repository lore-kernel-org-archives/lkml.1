Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZCROri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZCROri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZCROr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:47:29 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42501 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZCROr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:47:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 18 Mar 2009 07:46:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com
Subject: Re: [patch] eventfd - remove fput() call from possible IRQ context
 (2nd rev)
In-Reply-To: <x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.DEB.1.10.0903180743340.12617@makko.or.mcafeemobile.com>
References: <49B89B22.7080303@cosmosbay.com> <20090311224712.fb8db075.akpm@linux-foundation.org> <49B8A75E.6040409@cosmosbay.com> <20090311233903.f036027a.akpm@linux-foundation.org> <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>
 <1236986902.7265.73.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com> <1237003328.7265.98.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>
 <alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com> <20090315174445.GD18305@kvack.org> <alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com> <x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Jeff Moyer wrote:

> I agree with Jamie that you should get rid of the unlikely.

Ok, will repost today with typo and unlikely fixed.


- Davide


