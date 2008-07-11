Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYGKRCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYGKRCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYGKRCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:02:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54442 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYGKRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:02:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>
	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>
	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>
	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>
	<48763732.7020805@sgi.com> <487641D6.5060206@goop.org>
	<487649B2.3000405@sgi.com> <48764E8A.5010400@zytor.com>
	<4876766F.4030605@linux-foundation.org> <48767804.8080007@zytor.com>
	<48767A28.7070900@linux-foundation.org> <48767AF5.7030205@zytor.com>
	<48777D15.6040107@linux-foundation.org>
Date: Fri, 11 Jul 2008 09:57:54 -0700
In-Reply-To: <48777D15.6040107@linux-foundation.org> (Christoph Lameter's
	message of "Fri, 11 Jul 2008 10:32:37 -0500")
Message-ID: <m1hcawgxyl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Lameter <cl@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0162]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> x86_64 are small systems? For 64 bit use one would expect 4GB of memory.

Anything over 1G where 32bit runs out of lowmem starts to be a win.
Plus sometimes it just doesn't make sense to use a 32bit kernel.

Expecting 4GB of real memory seems silly.

Eric

