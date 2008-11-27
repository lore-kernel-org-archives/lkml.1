Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYK0K5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYK0K5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYK0KmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:42:03 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:30676 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbYK0KmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:42:01 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 2/2] tracing: identify which executable object the
 userspace address belongs to
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <y0my6z798de.fsf@ton.toronto.redhat.com>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
	 <1227353328-16104-3-git-send-email-edwintorok@gmail.com>
	 <y0my6z798de.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 11:41:45 +0100
Message-Id: <1227782505.4454.1393.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 09:40 -0500, Frank Ch. Eigler wrote:
> =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com> writes:
> 
> > Impact: modify+improve the userstacktrace tracing visualization feature
> > [...]
> > You'll see stack entries like:
> >    /lib/libpthread-2.7.so[+0xd370]
> > [...]
> 
> Can you suggest an actual distribution & architecture where this
> facility may be tested/used?  It appears to require frame-pointer
> stuff that AFAIK is not generally turned on for user-space.

gentoo, just rebuild world with frame pointers ;-)

