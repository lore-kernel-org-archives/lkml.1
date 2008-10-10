Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbYJJMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbYJJMNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYJJMNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:13:07 -0400
Received: from web38201.mail.mud.yahoo.com ([209.191.124.144]:38650 "HELO
	web38201.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754274AbYJJMNH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:13:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=VcCB/OqmiDAvQeIID3qhxcz4BoplMO9KJgJJxeysVbzV7EqNPmxymBNb0NHdtvLSnW8wnwCj8MMyhK7GiPpRnndeO1fnLUhQOs46mcw49DCXzX+NKLWtiwPq2zqMdbNhafwF+t4/xfJkd+VWp8OkDCOX+HCt7xuKSYRkeIDTbgM=;
X-YMail-OSG: E3cESGIVM1llFa3kJqi5XE712m25eVUPuqVp6GHLS6O_E98wOEFGwsMc.2Atu8Sa6eNlIbqGMlHbDPTo48yyYQhCmCbBenlYYp603PIa2pkC8moIEreyHZcpQokJY76nxk3fFPoVOR1X3j_bwn_aVDuxBxdPS3jUzf4RmG5ThShG1Q--
X-Mailer: YahooMailRC/1096.40 YahooMailWebService/0.7.218.2
Date: Fri, 10 Oct 2008 05:13:06 -0700 (PDT)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] drm: fix leak of uninitialized data to userspace
To: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegardno@ifi.uio.no>
Cc: Dave Airlie <airlied@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <356742.30067.qm@web38201.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ingo Molnar <mingo@elte.hu>

>
> i've stuck it into the tip/out-of-tree quick-fixes branch.

I've just got to say that testing Ingo's stuff is always an absolute pleasure. Ingo has pulled in test patches into his git tree which makes testing potential fixes many times easier for me (I've had yahoo mail mangle patches which would force me to rebuild the patch by hand rather than just apply it). The sheer speed of turn around is scarily impressive too. If you ever want to know how to get people to test your stuff Ingo's lead is a good one to follow.

> Sitsofe, could you please check very latest tip/master with 
> CONFIG_KMEMCHECK=y, does it find any other uninitialized memory access?

Give me a few minutes and I'll try and get back to you...



      
