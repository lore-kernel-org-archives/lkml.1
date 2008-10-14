Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbYJNUaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbYJNUaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYJNUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:30:03 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:41275 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750899AbYJNUaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:30:01 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 16:30:00 EDT
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
To: Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.25.17
Date: Tue, 14 Oct 2008 23:19:25 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
References: <20080908143516.GA7311@suse.de>
In-Reply-To: <20080908143516.GA7311@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810142319.33603.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

08 Eyl 2008 Pts tarihinde, Greg KH şunları yazmıştı: 
> We (the -stable team) are announcing the release of the 2.6.25.17
> kernel.
> 
> It contains lots of bugfixes, all over the map.  Any users of the 2.6.25
> kernel series should upgrade to this version.  For details on the fixes,
> see the changelog entries and the diffstat below.
[...]

> Yinghai Lu (1):
>       x86: work around MTRR mask setting

That particular patch causes _lots_ of WARN_ON messages on one of our servers and following commit in Linus's tree solved that problem. If -stable team will release another .25 update maybe following patch can be considered to solve that sitation introduced with 2.6.2.5.17

commit 9754a5b840a209bc1f192d59f63e81b698a55ac8
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Aug 22 08:22:23 2008 +0200

    x86: work around MTRR mask setting, v2

    improve the debug printout:

    - make it actually display something
    - print it only once

    would be nice to have a WARN_ONCE() facility, to feed such things to
    kerneloops.org.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
