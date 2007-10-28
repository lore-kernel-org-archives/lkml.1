Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXJ1StQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXJ1StQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbXJ1StC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:49:02 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51260 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXJ1StA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:49:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 28 Oct 2007 11:48:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: David Schwartz <davids@webmaster.com>
cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: RE: epoll design problems with common fork/exec patterns
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEEDHNAC.davids@webmaster.com>
Message-ID: <Pine.LNX.4.64.0710281143510.28544@alien.or.mcafeemobile.com>
References: <MDEHLPKNGKAHNMBLJOLKIEEDHNAC.davids@webmaster.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, David Schwartz wrote:

> 	I don't see how that can be. Suppose I add fd 8 to an epoll set. Suppose fd
> 5 is a dup of fd 8. Now, I close fd 8. How can fd 8 remain in my epoll set,
> since there no longer is an fd 8? Events on files registered for epoll
> notification are reported by descriptor, so the set membership has to be
> associated (as reflected into userspace) with the descriptor, not the file.

Eric already answered to your question (epoll deals with internal kernel 
objects - aka file*).
I just want to answer this one for another reason. WTF is wrong with all 
of you Cc-list-trimmers?
Could you *please* stop trimming Cc-lists?



- Davide


