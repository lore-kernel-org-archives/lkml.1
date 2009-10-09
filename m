Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbZJIJCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbZJIJCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760416AbZJIJCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:02:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:50452 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301AbZJIJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:02:48 -0400
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
 kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090720100157.GA6467@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 11:02:09 +0200
Message-Id: <1255078929.17055.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 12:01 +0200, Sam Ravnborg wrote:
> This works both for plain builds and for O=...
> builds.
> So now you can do:
> $ mkdir sparc64
> $ make O=sparc64 ARCH=sparc64 CROSS_COMPILE=sparc64-linux- defconfig
> $ cd sparc64
> $ make

Like anyone who does a lot of cross builds will ever write that by
hand..

