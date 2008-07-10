Return-Path: <linux-kernel-owner+w=401wt.eu-S1762439AbYGJTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762439AbYGJTMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYGJTMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:12:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53168 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbYGJTMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:12:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>
	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>
	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>
	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>
	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>
	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>
	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org>
	<m1prpl4pmh.fsf@frodo.ebiederm.org> <48764C21.4020601@zytor.com>
Date: Thu, 10 Jul 2008 12:09:21 -0700
In-Reply-To: <48764C21.4020601@zytor.com> (H. Peter Anvin's message of "Thu,
	10 Jul 2008 13:51:29 -0400")
Message-ID: <m1fxqhzhcu.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1486]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Almost half a megabyte in current allyesconfig, and that is not including
> dynamic allocations at all.

Ouch!  This start to make me sad I removed the arbitrary cap on static
percpu memory.

Eric
