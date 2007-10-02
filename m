Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXJBLEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXJBLEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbXJBLEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:04:38 -0400
Received: from snape.gogi.tv ([217.160.142.238]:2090 "EHLO snape.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXJBLEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:04:38 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 07:04:38 EDT
From: Giuliano Gagliardi <gogi-k@gogi.tv>
Reply-To: gogi-k@gogi.tv
To: linux-kernel@vger.kernel.org
Subject: One process with multiple user ids.
Date: Tue, 2 Oct 2007 12:56:08 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021256.08469.gogi-k@gogi.tv>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a server that has to switch to different user ids, but because it does 
other complex things, I would rather not have it run as root. I only need the 
server to be able to switch to certain pre-defined user ids.

I have seen that two possible solutions have already been suggested here on 
the LKML, but it was some years ago, and nothing like it has been 
implemented.

(1) Having supplementary user ids like there are supplementary group ids and 
system calls getuids() and setuids() that work like getgroups() and 
setgroups()

(2) Allowing processes to pass user and group ids via sockets.

Both (1) and (2) would solve my problem. Now my question is whether there are 
any fundamental flaws with (1) or (2), or whether the right way to solve my 
problem is another one.

Giuliano
