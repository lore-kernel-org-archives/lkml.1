Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXBLICP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXBLICP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXBLICP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:02:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:51462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085AbXBLICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:02:14 -0500
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] file access time in millisecond?
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
From: Andi Kleen <ak@suse.de>
Date: 12 Feb 2007 10:02:28 +0100
In-Reply-To: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
Message-ID: <p73bqjzhhp7.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jeff Chua" <jeff.chua.linux@gmail.com> writes:

> Is it possible to get file access time in millisecond resolution?
> 
> stat() returns time in seconds,

Not correct (at least for glibc stat). It supports nanoseconds these days,
although not all file systems (including ext3) do yet.

Some of the old stat compat emulations do not.

-Andi
