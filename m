Return-Path: <linux-kernel-owner+w=401wt.eu-S1423046AbXCGRni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423046AbXCGRni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965625AbXCGRnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:43:37 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42649 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965620AbXCGRms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:42:48 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 09:42:37 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <20070307233833.f1482f86.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0703070938470.12283@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Stephen Rothwell wrote:

> Then, of course, you have to think about how to get the siginfo_t out to
> the user process.  Do you just return it from the read after the read
> that returns the signal number?  If so, you need to know if the process
> did a compat read syscall read or a normal one ...

It can be a read(2) of a structure that does not need compat. It must be 
that way, because compat-on-read are out of question.



- Davide


