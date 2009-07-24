Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZGXTOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZGXTOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZGXTOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:14:03 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:33210 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZGXTOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VzM2pQCxrw6j6C07PQVdr4kkRg8wza9MpVHmvYydwXtwbQ3EMUyRVqLpGncmwl67kv
         bZRVGLpZCOPmCSJR3uJyuqCXlrNARw+pL8LeUAnDGupKbALJS+swB+vhTfyE2wXQTlZ/
         mrT7ZmeLlyHtNJ+bY1LYuENZkEF9+hdt3vV2M=
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 15:14:00 -0400
Message-ID: <9871ee5f0907241214n3667740ekcee82c98063c8283@mail.gmail.com>
Subject: 2.6.30 BUG? Full load, but nice levels cause CPU idle time?
From: Timothy Normand Miller <theosib@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not subscribed, so please include me in the CC on this.

I'm running 2.6.30 (gentoo).  I have a quad core (Intel Q9450), and I
have four CPU intensive processes running.  Three of them are set to
nice +5, while one is at +0.  When I look at the CPU load in top, I
find that the +0 gets 100% of a CPU to itself.  The three +5's are
sharing two CPUs, leaving the fourth CPU completely idle.

Is this supposed to happen?  It seems to me that if there's work to
do, no CPU should be left idle, right?

Thanks.

-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
