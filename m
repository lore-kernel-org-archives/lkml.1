Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZI3ObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZI3ObV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZI3ObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:31:20 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:5138 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752299AbZI3ObU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:31:20 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz1432Rzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQSGBI-02-MQV-02
X-M-MSG: 
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "'Joerg Roedel'" <joro@8bytes.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
       "davej@redhat.com" <davej@redhat.com>
Date: Wed, 30 Sep 2009 09:30:57 -0500
Subject: RE: [PATCH] Option to synchronize P-states for  AMD family 0xf
Thread-Topic: [PATCH] Option to synchronize P-states for  AMD family 0xf
Thread-Index: AcpBtO/C8TGxhGhiRjShcKkzau2FQQAJWR9A
Message-ID: <DDE95BDD51FB774B804A9C029E735EE10379BEDA68@sausexmbp02.amd.com>
References: <200909291623.56130.mark.langsdorf@amd.com>
 <20090930100059.GG29634@8bytes.org>
In-Reply-To: <20090930100059.GG29634@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > AMD Family 0xf processors (Athlon 64s and Opterons) do not
> > have P-State or C-State invariant TSCs.  Instead, the TSC
> > increments at the current processor frequency, which makes
> > it unstable and unreliable if cpufreq is enabled.
> > 
> > This patch introduces a new command parameter for the
> > PowerNow! driver called "tscsync".  When tscsync is
> > set to 1, the driver forces all processors in the system
> > to change frequency as the same time to the same frequency.
> > This unified change means that all the TSCs in the system
> > increment at the same rate.
> 
> Cool feature. Does Linux consider the TSC as stable on these machines
> even after a longer uptime (say after a week)?

Ask me in a week.  Linux time-keeping code has evolved
quite a bit since I last looked at this code.

-Mark Langsdorf
Operating System Research Center
AMD
