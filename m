Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbYGJTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbYGJTLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYGJTLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:11:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36358 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754750AbYGJTLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:11:39 -0400
Message-ID: <48765EEA.1060703@sgi.com>
Date: Thu, 10 Jul 2008 12:11:38 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <m1prpl4pmh.fsf@frodo.ebiederm.org> <4876492E.90901@linux-foundation.org>
In-Reply-To: <4876492E.90901@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
...
> The patches are reasonably small. The problem that Mike seems to have is early boot debugging.

Note that the early boot debugging problems go away with gcc-4.2.4.  My
problem now (what I [maybe incorrectly] believe) is stack overflow with
NR_CPUS=4096 and a specific random config file.

Btw, I've completed the first half of splitting the zero_based_fold into
zero_based_only and fold_pda_into_percpu and am testing that now.


