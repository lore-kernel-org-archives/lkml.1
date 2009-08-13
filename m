Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZHMJ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZHMJ1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZHMJ1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:27:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64545 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbZHMJ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:27:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 0/7] new kfifo API
Date: Thu, 13 Aug 2009 09:27:21 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Stefani Seibold <stefani@seibold.net>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
References: <1250029873.17599.98.camel@wall-e> <20090813030903.GC5031@cr0.nay.redhat.com>
In-Reply-To: <20090813030903.GC5031@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908130927.22124.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+8431Xed5WObQub565EIzJ5uDrMtDxUrr4GdV
 +QdrLTeR2x5N3X3jCZADGNxXGQJzQn6nXC/2twBVtM879F/M2Y
 z9yYSgQej6FU/B7tzPAlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009 03:09:03 Amerigo Wang wrote:

> And, personally I don't like your splitting of these patches,
> I prefer to see kfifo API changes first, then their usages.
 
Note that they are relatively hard to split without breaking
git-bisect. That can only work if you are able to introduce
the API under a different name first and then change the
users, finally removing the old API.

	Arnd <><
