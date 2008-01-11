Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbYAKGlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbYAKGlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYAKGlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:41:10 -0500
Received: from rosi.naasa.net ([212.8.0.13]:55417 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYAKGlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:41:09 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Fri, 11 Jan 2008 07:41:01 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <400029009.12072@ustc.edu.cn> <200801110629.48569.jplatte@naasa.net>
In-Reply-To: <200801110629.48569.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801110741.03028.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 11. Januar 2008 schrieb Joerg Platte:

> konqueror   987    jplatte  mem       REG        8,6  2590525
> 1336104 /var/tmp/kdecache-jplatte/ksycoca
> konqueror   987    jplatte   12r      REG        8,6  2590525
> 1336104 /var/tmp/kdecache-jplatte/ksycoca
> konqueror   987    jplatte   13u      REG        8,7      579
> 97731 /tmp/kde-jplatte/konqueror-crash-Jv2u8a.log
> konqueror   987    jplatte   14u      REG        8,7   128289
> 97734 /tmp/kde-jplatte/khtmlcacheA7VjAa.tmp (deleted)
> konqueror   987    jplatte   16u      REG        8,7    43334
> 97750 /tmp/kde-jplatte/khtmlcacheZUNlsc.tmp (deleted)
> konqueror   987    jplatte   22u      REG        8,7      797
> 97751 /tmp/kde-jplatte/khtmlcache76bZYa.tmp (deleted)
> konqueror   987    jplatte   27u      REG        8,7   102347
> 97735 /tmp/kde-jplatte/khtmlcacheMhlDJb.tmp (deleted)
> konqueror   987    jplatte   31u      REG        8,7      354
> 97738 /tmp/kde-jplatte/khtmlcacheq21uoc.tmp (deleted)
> konqueror   987    jplatte   32u      REG        8,7     1360
> 97742 /tmp/kde-jplatte/khtmlcacheo2Ms2a.tmp (deleted)
> konqueror   987    jplatte   34u      REG        8,7     6378
> 97745 /tmp/kde-jplatte/khtmlcacheLETtgc.tmp (deleted)
> konqueror   987    jplatte   35u      REG        8,7    97350
> 97746 /tmp/kde-jplatte/khtmlcache5jit8a.tmp (deleted)
> konqueror   987    jplatte   36u      REG        8,7      354
> 97747 /tmp/kde-jplatte/khtmlcache7VBSNa.tmp (deleted)
> konqueror   987    jplatte   37u      REG        8,7     1360
> 97748 /tmp/kde-jplatte/khtmlcachetSNbub.tmp (deleted)
> konqueror   987    jplatte   38u      REG        8,7     6073
> 97749 /tmp/kde-jplatte/khtmlcacheKAKhuc.tmp (deleted)

Fengguang, a few minutes after killing this konqueror process the high iowait 
load has disappeared. Lets see if it'll come back...

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605
