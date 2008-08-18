Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbYHRTJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbYHRTJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762825AbYHRTF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:05:28 -0400
Received: from isilmar.linta.de ([213.133.102.198]:40475 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762821AbYHRTFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:05:20 -0400
Date: Mon, 18 Aug 2008 21:03:25 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Cc: john stultz <johnstul@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Andreas Mohr <andi@lisas.de>
Subject: [git pull?] clocksource: ACPI pmtmr bugfixes [Was: Re: ACPI
	PM-Timer on K6-3 SiS5591: Houston...]
Message-ID: <20080818190325.GA12581@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andreas Mohr <andi@lisas.de>
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810190759.GA1879@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

anyone willing to take these two patches? Possibly 2.6.27 material; hasn't
been in -next or -mm.

Best,
	Dominik


The following changes since commit 796aadeb1b2db9b5d463946766c5bbfd7717158c:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git clocksource

Dominik Brodowski (2):
      acpi_pm.c: use proper read function also in errata mode.
      acpi_pm.c: check for monotonicity

 drivers/clocksource/acpi_pm.c |   50 +++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 21 deletions(-)
