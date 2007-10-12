Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbXJLM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbXJLM1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXJLM1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:27:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:36310 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751267AbXJLM1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:27:10 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+Hp2hrYBCHi5xkJ6/1CQBQyAshyHB57u8UlKTHH6
	PzjNhEBLWMa42X
Date: Fri, 12 Oct 2007 14:27:19 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the rationale for "TAINT_USER"?
Message-ID: <20071012122719.GB30350@atjola.homenet>
References: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.10.12 08:04:20 -0400, Robert P. J. Day wrote:
> 
>   i can see what the theoretical purpose for it is here:
> 
> http://kerneltrap.org/node/6656
> 
> but it's not clear how it can possibly be set from userland given
> that:
> 
> $ grep -r TAINT_USER *
> include/linux/kernel.h:#define TAINT_USER                       (1<<6)
> kernel/panic.c:                 tainted & TAINT_USER ? 'U' : ' ',
> $
> 
>   am i missing something screamingly obvious?

Grepping for "tainted" leads me to:

echo 32 > /proc/sys/kernel/tainted

Björn
