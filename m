Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYLCBVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYLCBVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYLCBV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:21:27 -0500
Received: from cmpxchg.org ([85.214.51.133]:33824 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbYLCBV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:21:26 -0500
Date: Wed, 3 Dec 2008 02:20:52 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: drop const qualifier for kernel_execve()
Message-ID: <20081203012051.GA8953@cmpxchg.org>
References: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 10:51:09PM +0000, Américo Wang wrote:
> UML implementation of kernel_execve() should not have const qualifier,
> because it will finally call do_execve() which doesn't have.

And you made sure that do_execve() is correctly annotated?

	Hannes
