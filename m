Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZKWEcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZKWEcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 23:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZKWEcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 23:32:47 -0500
Received: from mfo11.iijmio.jp ([210.138.77.173]:35435 "EHLO mfo11.iijmio.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbZKWEcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 23:32:46 -0500
X-Greylist: delayed 2202 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2009 23:32:46 EST
Date: Mon, 23 Nov 2009 12:55:48 +0900
From: Hideki Yamane <henrich@debian.or.jp>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hideki Yamane" <henrich@debian.or.jp>
Subject: Re: [Bug #14588] Kernel panic - not syncing: stack-protector:
 Kernel stack is corrupted in: ccccb5b0
Message-Id: <20091123125548.e12fe7bd.henrich@debian.or.jp>
In-Reply-To: <mYW9sxtWd2G.A.YkE.xCACLB@chimera>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	<mYW9sxtWd2G.A.YkE.xCACLB@chimera>
Organization: Debian JP Project
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 21 Nov 2009 16:02:17 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14588
> Subject		: Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ccccb5b0
> Submitter	: Hideki Yamane <henrich@debian.or.jp>
> Date		: 2009-11-12 02:25 (10 days old)

 With 2.6.32-rc8, it works for me. 

henrich@hatchpotch:~$ uname -a
Linux hatchpotch 2.6.32-rc8 #5 SMP Sun Nov 22 22:32:12 JST 2009 i686 GNU/Linux

henrich@hatchpotch:~$ grep STACKPROTECT /boot/config-2.6.32-rc8 
CONFIG_CC_STACKPROTECTOR=y

-- 
Regards,

 Hideki Yamane     henrich @ debian.or.jp/iijmio-mail.jp
 http://wiki.debian.org/HidekiYamane
