Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYGIVCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYGIVCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbYGIVB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:01:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44039 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYGIVBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:01:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org>
	<4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>
	<487502FB.3090106@sgi.com> <487507A1.2020100@goop.org>
	<m1r6a2yfip.fsf@frodo.ebiederm.org> <4875212E.6090404@goop.org>
Date: Wed, 09 Jul 2008 13:53:12 -0700
In-Reply-To: <4875212E.6090404@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 09 Jul 2008 13:35:58 -0700")
Message-ID: <m18wwavkxz.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0092]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

>> Or we could do something completely evil.  And use the other segment
>> register for the stack canary.
>>
>
> That would still require gcc changes, so it doesn't help much.

We could use %fs for the per cpu variables.  Then we could set %gs to whatever
we wanted to sync up with gcc

Eric
