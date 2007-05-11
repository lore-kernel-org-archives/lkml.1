Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbXEKPJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbXEKPJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbXEKPJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:09:29 -0400
Received: from gw.goop.org ([64.81.55.164]:33513 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968AbXEKPJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:09:28 -0400
Message-ID: <46448726.5040706@goop.org>
Date: Fri, 11 May 2007 08:09:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: 2.6.21-git11: BUG in loop.ko
References: <46425EC9.5070209@goop.org>	 <20070509170521.ec2c9ae7.akpm@linux-foundation.org> <b040c32a0705102310m5ec647an2b3aa9f74e2ed450@mail.gmail.com>
In-Reply-To: <b040c32a0705102310m5ec647an2b3aa9f74e2ed450@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:
> So loop_probe() mistakenly returned wrong status and leads to future
> oops on inconsistent module ref count.  The following patch fixes the
> issue.
>
> Signed-off-by: Ken Chen <kenchen@google.com>

Yep, works for me.

Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

    J
