Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbXCaBOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbXCaBOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933279AbXCaBOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:14:30 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47604 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbXCaBO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:14:29 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Mar 2007 18:14:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 10/13] signal/timer/event fds v8 - eventfd core ...
In-Reply-To: <Pine.LNX.4.64.0703301804110.3721@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703301813290.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415840.10>
 <20070330124028.c6e54d2e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703301804110.3721@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Davide Libenzi wrote:

> > Some architectures do not implement 64-bit get_user()
> 
> copy_from_user it is, then ...

That's messed up though. We do have put_user and we miss get_user. Bah...



- Davide


