Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZKRRxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZKRRxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbZKRRxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:53:00 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:12324
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757991AbZKRRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:52:59 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz1432R98dNzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B043467.8000708@am.sony.com>
Date: Wed, 18 Nov 2009 09:52:39 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Matt Mackall <mpm@selenic.com>, David VomLehn <dvomlehn@cisco.com>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>,
       Marco Stornelli <marco.stornelli@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "dwm2@infradead.org" <dwm2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <1258463404.27437.103.camel@localhost>	<m1pr7hf93s.fsf@fess.ebiederm.org>	<20091117235627.GA13469@dvomlehn-lnx2.corp.sa.net>	<m1iqd8ptg9.fsf@fess.ebiederm.org> <1258505777.3081.4.camel@calx> <m1vdh7byva.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdh7byva.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2009 17:52:40.0667 (UTC) FILETIME=[EC336AB0:01CA6877]
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Matt Mackall <mpm@selenic.com> writes:
> 
>> As much as I like kexec, it loses on memory footprint by about 100x.
>> It's not appropriate for all use cases, especially things like
>> consumer-grade wireless access points and phones.
> 
> In general I agree.  The cost of a second kernel and initrd can be
> prohibitive in the smallest systems, and if you do a crash capture
> with using a standalone app that is reinventing the wheel.
> 
> That said.  I can happily run kdump with only 16M-20M reserved.
> So on many systems the cost is affordable.

Understood.  On some of my systems, the memory budget for the
entire system is 10M.  On most systems I work with, it is a
struggle to reserve even 64K for this feature.
  -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

