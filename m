Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYJEBqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYJEBqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 21:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYJEBq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 21:46:29 -0400
Received: from main.gmane.org ([80.91.229.2]:53700 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbYJEBq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 21:46:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rafal <newsgroup@limcore.com>
Subject: Re: Kernel unable to adjust timeofday
Date: Sun, 05 Oct 2008 03:46:16 +0200
Organization: LimCore.com
Message-ID: <gc9698$249$1@ger.gmane.org>
References: <gbio4j$aqq$1@ger.gmane.org> <47571.1222440706@turing-police.cc.vt.edu> <48DD3CAE.9050809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dbr215.neoplus.adsl.tpnet.pl
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:

> adjtimex --tick 9972
> 
> ... in your startup scripts, before ntpd is started.
> 
> If NTP still goes off the rails, then adjust the tick value in steps of
> about 5 until you can get it to converge.
> 
> -hpa

Hi,
after adjtimex --tick 10029 the calls to ntpdate pool.ntp.org seem to be
working:

5 Oct 03:42:37 ntpdate[13218]: adjust time [...] offset -0.318571 sec
5 Oct 03:42:44 ntpdate[13223]: adjust time [...] offset -0.318193 sec
5 Oct 03:43:14 ntpdate[13226]: adjust time [...] offset -0.317724 sec
5 Oct 03:43:49 ntpdate[13233]: adjust time [...] offset -0.326299 sec
5 Oct 03:45:01 ntpdate[13263]: adjust time [...] offset -0.325523 sec

Which seems to be improvement since previously the offset was increasing 0.1
0.2 0.3 etc, untill it reached 0.5 and then jumped to 0.

Now I will test with ntpd but I hope it will work this time;
Thanks

-- 
Rafał Maj
Software developer
http://www.limcore.com/

