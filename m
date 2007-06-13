Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbXFMT7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbXFMT7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXFMT7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:59:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6505 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbXFMT7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=oo2CKmlhLyNeWDCrCqtmdpULfRv7w/husNSNhGSNN7fVZ5sXyP65WXvIKL2mfqlp8+bxDdy9f7nMStdfthFceP6OIqgQcdFhpQLqSkfbHL1gA2ZQaBwoIZWi1YCJx30EGnKuqJ5l6CdoDoodUaOzE9lxmzuJHEc+clsKYUJSR5E=
Message-ID: <46704C47.40009@googlemail.com>
Date: Wed, 13 Jun 2007 21:57:59 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Christoph Lameter <clameter@sgi.com>, Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [1/2] 2.6.22-rc4: known regressions with patches v3
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : CONFIG_DEBUG_RODATA prevents kprobes from working on 2.6.22-rc2
References : http://lkml.org/lkml/2007/5/23/202
Submitter  : William Cohen <wcohen@redhat.com>
             Ian McDonald <ian.mcdonald@jandi.co.nz>
Handled-By : S. P. Prasanna <prasanna@in.ibm.com>
Patch      : http://lkml.org/lkml/2007/6/7/2
Status     : patch available

Subject    : kernel BUG at arch/i386/kernel/cpu/perfctr-watchdog.c:126!
References : http://lkml.org/lkml/2007/6/3/60
Submitter  : Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
Patch      : http://lkml.org/lkml/2007/6/8/23
Status     : patch available



Memory management

Subject    : kernel BUG at mm/slub.c:3689!
References : http://lkml.org/lkml/2007/6/11/121
Submitter  : Haavard Skinnemoen <hskinnemoen@atmel.com>
Handled-By : Christoph Lameter <clameter@sgi.com>
Patch      : http://lkml.org/lkml/2007/6/11/405
             http://lkml.org/lkml/2007/6/12/110
Status     : patch was suggested

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
