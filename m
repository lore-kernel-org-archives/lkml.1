Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab0BRSAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:00:33 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:42184 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab0BRSA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:00:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pBaYO/AzkxtuCQi+PjYiI3ZfJJqsApUo1HA+iGDyszrGxKtLTe+qfgG8K9Anrm0/A8
         fLooRQ3vPSHgWFy67vJYDZd0YdLgbtcTwzn/DWsfCzrD2SeIBNiTuDaC1NDhU/kAkcj1
         i6FHn67HpW44dPtXTIcadbNm7HqdkVCT3+lSA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Michael Stefaniuc <mstefani@redhat.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Regression in ptrace (Wine) starting with 2.6.33-rc1, fixes
Date: Thu, 18 Feb 2010 18:59:59 +0100
Message-Id: <1266516001-7753-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <4B7881AC.5070209@redhat.com>
References: <4B7881AC.5070209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael, all,

I still can't build the wine tree (even with the wine faq)
because of the following error:

LD_LIBRARY_PATH="../../libs/wine:$LD_LIBRARY_PATH" ../../tools/wrc/wrc --nostdinc -I. -I. -I../../include -I../../include  -D__WINESRC__ -D_KERNEL32_  -folocale_rc.res locale_rc.rc
Source: �Q�� a4 51 a4 eb
Unicode:  5341 6708
Back: �̤� a2 cc a4 eb
nls/cht.nls:84:16: Error: String �Q�� does not convert identically to Unicode and back in codepage 950. Try using a Unicode string instead
make[1]: *** [locale_rc.res] Erreur 1

So I can't test these fixes by myself (although I've tested locally
with a home made POKEUSER -> PEEKUSER match test).

Could you please test the following tree? You can pull it on top
of Linus tree, or clone it.

It's here:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
