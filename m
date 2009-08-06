Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZHFIsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZHFIsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZHFIsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:48:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33845 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZHFIsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:48:02 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>, Bernhard Walle <bwalle@suse.de>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<m1eirqtmey.fsf@fess.ebiederm.org>
	<20090805140408.GJ7259@hmsreliant.think-freely.org>
	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>
	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>
	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>
	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com>
	<m1iqh1nxv3.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 06 Aug 2009 01:47:56 -0700
In-Reply-To: <m1iqh1nxv3.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 06 Aug 2009 01\:35\:28 -0700")
Message-ID: <m13a85nxab.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, bwalle@suse.de, andi@firstfloor.org, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, nhorman@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 0/7] Implement crashkernel=auto
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm.  I half take it back.  How is crashkernel=auto and then shrinking
the reserved size better than the extended syntax Bernhard Walle
introduced nearly two years ago?

Eric
