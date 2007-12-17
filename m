Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbXLQNIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbXLQNIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXLQNIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:08:05 -0500
Received: from [212.12.190.227] ([212.12.190.227]:56980 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752650AbXLQNIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:08:04 -0500
From: Al Boldi <a1426z@gawab.com>
To: "Indan Zupancic" <indan@nul.nu>,
       "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Date: Mon, 17 Dec 2007 16:05:31 +0300
User-Agent: KMail/1.5
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <47650A4C.4000708@davidnewall.com> <200712170040.lBH0e6sf099887@www262.sakura.ne.jp> <54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
In-Reply-To: <54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712171605.31084.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Mon, December 17, 2007 01:40, Tetsuo Handa wrote:
> > So, use of this filesystem alone is meaningless because
> > attackers with root privileges can do what you are saying.
> > But use of this filesystem with MAC is still valid because
> > MAC can prevent attackers with root privileges from doing what you are
> > saying.
>
> If MAC can avoid all that, then why can't it also avoid tampering with
> /dev? What security does your filesystem add at all, if it's useless
> without a MAC doing all the hard work?

I think the answer is obvious:  Tetsuo wants to add functionality that the 
MACs are missing.  So, instead of adding this functionality per MAC, he 
proposes to add it as ground work, to be combined with any MAC.

> I think you can better spend your time on read-only bind mounts.

That would be too coarse.


Thanks!

--
Al

