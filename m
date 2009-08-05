Return-Path: <linux-kernel-owner+w=401wt.eu-S934399AbZHENeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399AbZHENeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934359AbZHENeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:34:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48655 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934324AbZHENeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:34:03 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 Aug 2009 06:33:57 -0700
In-Reply-To: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Wed\, 5 Aug 2009 07\:19\:02 -0400")
Message-ID: <m1eirqtmey.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, nhorman@redhat.com, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0816]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 0/7] Implement crashkernel=auto
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> This series of patch implements automatically reserved memory for crashkernel,
> by introducing a new boot option "crashkernel=auto". This idea is from Neil.
>
> In case of breaking user-space applications, it modifies this boot option after
> it decides how much memory should be reserved.
>
> On different arch, the threshold and reserved memory size is different. Please
> refer patch 7/7 which contains an update for the documentation.
>
> Note: This patchset was only tested on x86_64 with differernt memory sizes.

This seems like a silly hard code. Especially for a feature distros don't
care enough about to implement a working initrd for.

Has anyone bothered to justify those large amounts of memory?
Where does the 128M go?

Please pardon me for being a cynic but I don't see the command line option
being the bottleneck for real users to make this work.

Eric
